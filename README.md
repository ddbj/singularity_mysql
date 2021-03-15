# singularity_mysql

遺伝研スパコンでユーザー権限でMySQLデータベースを実行するためのsingularity imageの使い方

## imageの生成

自分の環境でimageをbuildする場合は、以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_mysql.git
    $ cd singularity_mysql
    $ sudo singularity build ubuntu-18.04-mysql-5.6.51.simg Singularity.5.6

## imageのダウンロード

Singularity Hubに登録されたイメージをダウンロードする場合は以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_mysql.git
    $ cd singularity_mysql
    $ singularity pull --name ubuntu-18.04-mysql-5.6.46.simg shub://ddbj/singularity_mysql:5.6


## MySQLデータベースの初期化

生成またはダウンロードしたイメージだけではMySQLデータベースを実行できません。
singularity instanceを起動し、データベースの初期化・mysqlのrootユーザーの設定等を行います。
コマンド実行前に、自分の環境に合わせて start_container.sh の CONTAINER_HOME, IMAGE, INSTANCE変数と　my_mysql.cnf の port（2か所）を修正してください。

- IMAGE: singularity buildまたはsingularity pullした際に指定したイメージのファイル名を記載します。
- INSTANCE: 起動するsingularity instanceの名前を記載します。すでに実行されているinstanceの名前では新規にinstanceを起動できないので、適宜修正してください。
- port: mysqlが使用するポートを記載してください。デフォルトのポート番号は3306ですが、他と被らないように50000以上の任意の数値を指定してください。

### singularitry instanceの起動・データベースの初期化

    $ module load singularity
    $ bash start_container.sh
    $ singularity shell instance://インスタンス名
    > cd /usr/local/mysql
    > rm -rf data/*
    > ./scripts/mysql_install_db
    > exit

この操作で mysql_data ディレクトリが生成され、この中にMySQLデータベースが生成されます。

### singularitry instanceの再起動・mysqlのrootユーザーのパスワード設定等

    $ singularity instance stop インスタンス名
    $ bash start_container.sh
    $ singularity exec instance://インスタンス名 ln -s /usr/local/mysql/data/mysql.sock /tmp/mysql.sock
    $ singularity exec instance://インスタンス名 mysql_secure_installation
    $ singularity exec instnace://インスタンス名 rm /tmp/mysql.sock

rootユーザーのパスワードの設定等を行います。
"Enter current password for root (enter for none): "　では何も入力せずにEnterを押し、以降の質問には Y を入力すればよいです。

## MySQLデータベースの使用

### データベースの作成

    $ singularity exec instance://インスタンス名 mysql -uroot -p
    mysql> create database new_database;
    mysql> exit

### データベース・ユーザーの作成

アクセス元のホストをワイルドカード（%）で設定しておきます。

    $ singularity exec instance://インスタンス名 mysql -uroot -p
    mysql> grant all privileges on new_database.* to 'new_user'@'%' identified by 'new_password';
    mysql> exit

### singularitry instance内のMySQLデータベースへのアクセス

スパコン上のmysqlコマンドを使ってsingularity instance内のMySQLデータベースにアクセスする場合

    $ mysql -P <指定したポート番号> -u new_user -p
    Enter password: 
    ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2)

socketがないのでlocalhostではアクセスできません。-hオプションでsingularity instanceを起動したホスト名を指定します。例えばat111でsingularity instanceを起動した場合は以下のようになります。

    $ mysql -h at111 -P <指定したポート番号> -u new_user -p
    Enter password:
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MySQL connection id is 18
    Server version: 5.6.46 Source distribution
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MySQL [(none)]> exit
    Bye

別ホストからもアクセスできます。

    $ ssh at044
    Last login: Fri Nov  1 15:57:04 2019 from gw1
    $ mysql -h at111 -P <指定したポート番号> -u new_user -p
    Enter password:
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MySQL connection id is 14
    Server version: 5.6.46 Source distribution
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MySQL [(none)]> exit
    Bye
    
