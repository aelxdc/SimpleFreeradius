sql {
        dialect = "mysql"
        driver = "rlm_sql_mysql"
        sqlite {
                filename = "/tmp/freeradius.db"
                busy_timeout = 200
                bootstrap = "${modconfdir}/${..:name}/main/sqlite/schema.sql"
        }
        mysql {
                warnings = auto
        }
        postgresql {
                send_application_name = yes
        }
        mongo {
                appname = "freeradius"
                tls {
                        certificate_file = /path/to/file
                        certificate_password = "password"
                        ca_file = /path/to/file
                        ca_dir = /path/to/directory
                        crl_file = /path/to/file
                        weak_cert_validation = false
                        allow_invalid_hostname = false
                }
        }
        server = "127.0.0.1"
        port = 3306
        login = "radius"
        password = "radpass"
        radius_db = "radius"
        acct_table1 = "radacct"
        acct_table2 = "radacct"
        postauth_table = "radpostauth"
        authcheck_table = "radcheck"
        groupcheck_table = "radgroupcheck"
        authreply_table = "radreply"
        groupreply_table = "radgroupreply"
        usergroup_table = "radusergroup"
        delete_stale_sessions = yes
        pool {
                start = ${thread[pool].start_servers}
                min = ${thread[pool].min_spare_servers}
                max = ${thread[pool].max_servers}
                spare = ${thread[pool].max_spare_servers}
                uses = 0
                retry_delay = 30
                lifetime = 0
                idle_timeout = 60
                max_retries = 5
        }
        read_clients = yes
        client_table = "nas"
        group_attribute = "SQL-Group"
        $INCLUDE ${modconfdir}/${.:name}/main/${dialect}/queries.conf
}
