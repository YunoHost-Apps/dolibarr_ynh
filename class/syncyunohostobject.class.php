<?php
/* Copyright (C) 2023 Syncyunohost Developers */

require_once DOL_DOCUMENT_ROOT.'/core/class/commonobject.class.php';

class SyncyunohostObject extends CommonObject
{
    public $module = 'syncyunohost';
    public $fields=array();
     /**
     * @var DoliDB Database handler
     */
    public $db;

    /**
     * Constructor
     * @param DoliDB $db Database handler
     */
    public function __construct(DoliDB $db)
    {
        $this->db = $db;
    }

    /**
     * Execute scheduled synchronization job
     * @return int 0 if OK, >0 if KO
     */
    public function doScheduledJob()
    {
        $error = 0;
        $this->output = '';
        $this->error = '';
        $now = dol_now();
        $past_date = $now - 24 * 3600; // 24 hours ago

        // Use prepared statement for security and better readability
        $sql = "SELECT s.fk_adherent";
        $sql .= " FROM " . MAIN_DB_PREFIX . "subscription AS s";
        $sql .= " WHERE s.datefin BETWEEN ? AND ?";
        $sql .= " ORDER BY s.datefin"; // Optional sorting

        dol_syslog(get_class($this) . "::doScheduledJob", LOG_DEBUG);

        try {
            $result = $this->db->query($sql, array($this->db->idate($past_date), $this->db->idate($now)));

            if ($result) {
                require_once DOL_DOCUMENT_ROOT . '/adherents/class/adherent.class.php';
                
                // Optimized loop using direct fetch
                while ($obj = $this->db->fetch_object($result)) {
                    $member = new Adherent($this->db);
                    $fetchResult = $member->fetch($obj->fk_adherent);

                    if ($fetchResult > 0) {
                        // Error handling for trigger call
                        try {
                            $this->call_trigger('MEMBER_SUBSCRIPTION_EXPIRED', $member);
                        } catch (Exception $e) {
                            $error++;
                            dol_syslog(__METHOD__ . " Error in trigger for member {$obj->fk_adherent}: " . $e->getMessage(), LOG_ERR);
                        }
                    } else {
                        $error++;
                        dol_syslog(__METHOD__ . " Failed to fetch member {$obj->fk_adherent}", LOG_ERR);
                    }
                }
                
                $this->db->free($result); // Free result resources
            }

            // Commit only if there are write operations
            // $this->db->commit();
            
            dol_syslog(__METHOD__ . " Action Expired Member done successfully", LOG_INFO);

        } catch (Exception $e) {
            $this->db->rollback();
            $error++;
            $this->error = $e->getMessage();
            dol_syslog(__METHOD__ . " Error: " . $this->error, LOG_ERR);
        }

        return $error;
    }

}