/* *********************************************** */

create or replace package PKG_MYENV as
 /* #Ver:1.0# */
    type     T_MYENV_TAB is table of varchar2( 32000 ) index by varchar2( 2000 );

    G_MYENV  T_MYENV_TAB;

    ------------------------------------------------------------------------
    procedure P_SET_MYENV ( I_INDEX in varchar2 
                          , I_VALUE in varchar2
                          , I_AREA  in varchar2 default null
                          );

    ------------------------------------------------------------------------
    -- Use this in SQL selects!
    function F_SEL_MYENV ( I_INDEX in varchar2 
                         , I_AREA  in varchar2 default null
                         ) return varchar2;

    ------------------------------------------------------------------------
    -- Use this in PL/SQL!
    function F_GET_MYENV ( I_INDEX in varchar2 
                         , I_AREA  in varchar2 default null
                         ) return varchar2;

    ------------------------------------------------------------------------
    -- Add or remove anything to it!
    procedure P_INIT;

    ------------------------------------------------------------------------

end;
/


/* *********************************************** */

create or replace package body PKG_MYENV as
 /* #Ver:1.0# */

    G_SEP  char(1) := chr( 8 );   -- separates the index and area

    ------------------------------------------------------------------------

    procedure P_SET_MYENV ( I_INDEX in varchar2 
                          , I_VALUE in varchar2
                          , I_AREA  in varchar2 default null
                          ) is
    begin
        if I_AREA is null then
            G_MYENV ( upper( I_INDEX                    ) ) := I_VALUE;
        else
            G_MYENV ( upper( I_INDEX || G_SEP || I_AREA ) ) := I_VALUE;
        end if;
    end;

    ------------------------------------------------------------------------
    function F_SEL_MYENV ( I_INDEX in varchar2 
                         , I_AREA  in varchar2 default null
                         ) return varchar2 is
        pragma UDF;
    begin
        if I_AREA is null then
            return G_MYENV ( upper( I_INDEX                    ) );
        else
            return G_MYENV ( upper( I_INDEX || G_SEP || I_AREA ) );
        end if;
    exception when others then
        return null;
    end;

    ------------------------------------------------------------------------

    function F_GET_MYENV ( I_INDEX in varchar2 
                         , I_AREA  in varchar2 default null
                         ) return varchar2 is
    begin
        if I_AREA is null then
            return G_MYENV ( upper( I_INDEX                    ) );
        else
            return G_MYENV ( upper( I_INDEX || G_SEP || I_AREA ) );
        end if;
    exception when others then
        return null;
    end;

    ------------------------------------------------------------------------
    procedure P_INIT is
    begin
        
        begin
            G_MYENV.delete;
        exception when others then
            null;
        end;

        /* *********************************************

            ADD OR REMOVE ANYTHING !
            Package variables and/or constants...and/or 
            values from user/application parameter tables
            and/or really anything
    
        ********************************************* */
        ----------------------
        -- all parameter
        ----------------------
        for L_R in ( select name, value from V$PARAMETER order by name )
        loop
            P_SET_MYENV ( L_R.name, L_R.value, 'SESSION PARAMETERS' );
        end loop;

        ----------------------
        -- session NLS
        ----------------------
        for L_R in ( select parameter, value from NLS_SESSION_PARAMETERS order by parameter )
        loop
            P_SET_MYENV ( L_R.parameter, L_R.value, 'SESSION NLS' );
        end loop;

        ----------------------
        -- instance NLS
        ----------------------
        for L_R in ( select parameter, value from NLS_INSTANCE_PARAMETERS order by parameter )
        loop
            P_SET_MYENV ( L_R.parameter, L_R.value, 'INSTANCE NLS' );
        end loop;

        ----------------------
        -- database NLS
        ----------------------
        for L_R in ( select parameter, value from NLS_DATABASE_PARAMETERS order by parameter )
        loop
            P_SET_MYENV ( L_R.parameter, L_R.value, 'DATABASE NLS' );
        end loop;

        ----------------------
        -- USERENV
        ----------------------
        P_SET_MYENV ( 'AUDITED_CURSORID'        , SYS_CONTEXT( 'USERENV', 'AUDITED_CURSORID'      ), 'USERENV' );
        P_SET_MYENV ( 'AUTHENTICATION_DATA'     , SYS_CONTEXT( 'USERENV', 'AUTHENTICATION_DATA'   ), 'USERENV' );
        P_SET_MYENV ( 'AUTHENTICATION_TYPE'     , SYS_CONTEXT( 'USERENV', 'AUTHENTICATION_TYPE'   ), 'USERENV' );
        P_SET_MYENV ( 'BG_JOB_ID'               , SYS_CONTEXT( 'USERENV', 'BG_JOB_ID'             ), 'USERENV' );
        P_SET_MYENV ( 'CLIENT_IDENTIFIER'       , SYS_CONTEXT( 'USERENV', 'CLIENT_IDENTIFIER'     ), 'USERENV' );
        P_SET_MYENV ( 'CLIENT_INFO'             , SYS_CONTEXT( 'USERENV', 'CLIENT_INFO'           ), 'USERENV' );
        P_SET_MYENV ( 'CURRENT_SCHEMA'          , SYS_CONTEXT( 'USERENV', 'CURRENT_SCHEMA'        ), 'USERENV' );
        P_SET_MYENV ( 'CURRENT_SCHEMAID'        , SYS_CONTEXT( 'USERENV', 'CURRENT_SCHEMAID'      ), 'USERENV' );
        P_SET_MYENV ( 'CURRENT_SQL'             , SYS_CONTEXT( 'USERENV', 'CURRENT_SQL'           ), 'USERENV' );
        P_SET_MYENV ( 'CURRENT_USER'            , SYS_CONTEXT( 'USERENV', 'CURRENT_USER'          ), 'USERENV' );
        P_SET_MYENV ( 'CURRENT_USERID'          , SYS_CONTEXT( 'USERENV', 'CURRENT_USERID'        ), 'USERENV' );
        P_SET_MYENV ( 'DB_DOMAIN'               , SYS_CONTEXT( 'USERENV', 'DB_DOMAIN'             ), 'USERENV' );
        P_SET_MYENV ( 'DB_NAME'                 , SYS_CONTEXT( 'USERENV', 'DB_NAME'               ), 'USERENV' );
        P_SET_MYENV ( 'ENTRYID'                 , SYS_CONTEXT( 'USERENV', 'ENTRYID'               ), 'USERENV' );
        P_SET_MYENV ( 'EXTERNAL_NAME'           , SYS_CONTEXT( 'USERENV', 'EXTERNAL_NAME'         ), 'USERENV' );
        P_SET_MYENV ( 'FG_JOB_ID'               , SYS_CONTEXT( 'USERENV', 'FG_JOB_ID'             ), 'USERENV' );
        P_SET_MYENV ( 'GLOBAL_CONTEXT_MEMORY'   , SYS_CONTEXT( 'USERENV', 'GLOBAL_CONTEXT_MEMORY' ), 'USERENV' );
        P_SET_MYENV ( 'HOST'                    , SYS_CONTEXT( 'USERENV', 'HOST'                  ), 'USERENV' );
        P_SET_MYENV ( 'INSTANCE'                , SYS_CONTEXT( 'USERENV', 'INSTANCE'              ), 'USERENV' );
        P_SET_MYENV ( 'IP_ADDRESS'              , SYS_CONTEXT( 'USERENV', 'IP_ADDRESS'            ), 'USERENV' );
        P_SET_MYENV ( 'ISDBA'                   , SYS_CONTEXT( 'USERENV', 'ISDBA'                 ), 'USERENV' );
        P_SET_MYENV ( 'LANG'                    , SYS_CONTEXT( 'USERENV', 'LANG'                  ), 'USERENV' );
        P_SET_MYENV ( 'LANGUAGE'                , SYS_CONTEXT( 'USERENV', 'LANGUAGE'              ), 'USERENV' );
        P_SET_MYENV ( 'NETWORK_PROTOCOL'        , SYS_CONTEXT( 'USERENV', 'NETWORK_PROTOCOL'      ), 'USERENV' );
        P_SET_MYENV ( 'NLS_CALENDAR'            , SYS_CONTEXT( 'USERENV', 'NLS_CALENDAR'          ), 'USERENV' );
        P_SET_MYENV ( 'NLS_CURRENCY'            , SYS_CONTEXT( 'USERENV', 'NLS_CURRENCY'          ), 'USERENV' );
        P_SET_MYENV ( 'NLS_DATE_FORMAT'         , SYS_CONTEXT( 'USERENV', 'NLS_DATE_FORMAT'       ), 'USERENV' );
        P_SET_MYENV ( 'NLS_DATE_LANGUAGE'       , SYS_CONTEXT( 'USERENV', 'NLS_DATE_LANGUAGE'     ), 'USERENV' );
        P_SET_MYENV ( 'NLS_SORT'                , SYS_CONTEXT( 'USERENV', 'NLS_SORT'              ), 'USERENV' );
        P_SET_MYENV ( 'NLS_TERRITORY'           , SYS_CONTEXT( 'USERENV', 'NLS_TERRITORY'         ), 'USERENV' );
        P_SET_MYENV ( 'OS_USER'                 , SYS_CONTEXT( 'USERENV', 'OS_USER'               ), 'USERENV' );
        P_SET_MYENV ( 'PROXY_USER'              , SYS_CONTEXT( 'USERENV', 'PROXY_USER'            ), 'USERENV' );
        P_SET_MYENV ( 'PROXY_USERID'            , SYS_CONTEXT( 'USERENV', 'PROXY_USERID'          ), 'USERENV' );
        P_SET_MYENV ( 'SESSION_USER'            , SYS_CONTEXT( 'USERENV', 'SESSION_USER'          ), 'USERENV' );
        P_SET_MYENV ( 'SESSION_USERID'          , SYS_CONTEXT( 'USERENV', 'SESSION_USERID'        ), 'USERENV' );
        P_SET_MYENV ( 'SESSIONID'               , SYS_CONTEXT( 'USERENV', 'SESSIONID'             ), 'USERENV' );
        P_SET_MYENV ( 'TERMINAL'                , SYS_CONTEXT( 'USERENV', 'TERMINAL'              ), 'USERENV' );

        ----------------------
        -- APEX SESSION
        ----------------------
        P_SET_MYENV ( 'APP_USER'        , SYS_CONTEXT( 'APEX$SESSION', 'APP_USER'            ), 'APEX$SESSION' );
        P_SET_MYENV ( 'APP_SESSION'     , SYS_CONTEXT( 'APEX$SESSION', 'APP_SESSION'         ), 'APEX$SESSION' );
        P_SET_MYENV ( 'WORKSPACE_ID'    , SYS_CONTEXT( 'APEX$SESSION', 'WORKSPACE_ID'        ), 'APEX$SESSION' );

    end;

end;
/

/* *********************************************** */
