#  Set and get my environment variables

## Why?

I have four reasons:

1. because I like to manage the same things at the same place and with the same way
2. because this way to get a parameter value is faster than 
    * sys_context() function
    * v() function
    * to select value from any table
    * as fast as reading a package variables but it is
3. more flexible than a (named) package variables
4. it is usable from SQL as well

## How?

Very simple.
There is a package named: PKG_MYENV<br>
There is a table variable in it. This table contains the parameter values and indexed by the name of the parameters.<br>
There is **SET** procedure, and there are two **GET** functions. One for PL/SQL and another for SQL.<br>
(but I did not find any useful info about is there any sense to use UDF pragma in a package body)
And there is an **INIT** procedure to fill the table at any time when we need to do it.<br>
There is an optional thing to define the parameter name (key): **AREA**. 


## Usage

I created a LOGIN solution. See my LOGIN repository! That sets up the environment for a certain user.<br>
Call PKG_MYENV.P_INIT in the last row of this login script to fill up these parameters and their values into this MYENV.<br>
After this we can read these parameter values by this solution very fast.<br>
When we need to read a parameter value many many times, the response time will be very important.<br>

So, let's test it!

```sql
set timing on

-- how long does it take to set 500 parameters?
begin
    PKG_MYENV.G_MYENV.delete;
    for L_I in 1..500
    loop
         PKG_MYENV.P_SET_MYENV( to_char(L_I), to_char(L_I), 'CONTROL TEST');
    end loop;
end;
/

Elapsed: 00:00:00.006

-- init it collecting from other sources (less than 500 parameters)
begin
    PKG_MYENV.P_INIT;
end;
/

Elapsed: 00:00:00.015

-- selecting all
declare
    V_I     varchar2( 10000 ) := PKG_MYENV.G_MYENV.first;
begin
    loop
        exit when V_I is null;
        dbms_output.put_line (  V_I || ' : ' || PKG_MYENV.G_MYENV( V_I ) );
        V_I := PKG_MYENV.G_MYENV.next( V_I );
    end loop;
end;
/

Elapsed: 00:00:00.001
```

We can see that the reading the parameters from their original source takes approx. 10 times more time than reading them from this new table variable.

