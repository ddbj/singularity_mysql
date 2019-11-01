# singularity_mysql

遺伝研スパコンでユーザー権限でMySQLデータベースを実行するためのsingularity imageの使い方

## imageの生成

自分の環境でimageをbuildする場合は、以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_mysql.git
    $ cd singularity_mysql
    $ sudo singularity build ubuntu-18.04-mysql-5.6.46.simg Singularity

## imageのダウンロード

Singularity Hubに登録されたイメージをダウンロードする場合は以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_mysql.git
    $ cd singularity_mysql
    $ singularity pull --name ubuntu-18.04-mysql-5.6.46.simg shub://ddbj/singularity_mysql:5.6


## MySQLデータベースの初期化

生成またはダウンロードしたイメージだけではMySQLデータベースを実行できません。
singularity instanceを起動し、データベースの初期化・mysqlのrootユーザーの設定等を行います。
コマンド実行前に、自分の環境に合わせて start_container.sh の CONTAINER_HOME, IMAGE, INSTANCE変数と　my_mysql.cnf の port（2か所）を修正してください。

- CONTAINER_HOME: 本リポジトリをgit cloneしてできたディレクトリのフルパスを記載します。
- IMAGE: singularity buildまたはsingularity pullした際に指定したイメージのファイル名を記載します。
- INSTANCE: 起動するsingularity instanceの名前を記載します。すでに実行されているinstanceの名前では新規にinstanceを起動できないので、適宜修正してください。
- port: mysqlが使用するポートを記載してください。デフォルトのポート番号は3306ですが、他と被らないように50000以上の任意の数値を指定してください。

### インスタンスの起動・データベースの初期化

    $ bash start_container.sh
    $ singularity shell instance://インスタンス名
    > cd /usr/local/mysql
    > rm -rf data/*
    > ./scripts/mysql_install_db
    > exit

この操作で mysql_data ディレクトリが生成され、この中にMySQLデータベースが生成されます。

### インスタンスの再起動・mysqlのrootユーザーのパスワード設定等

    $ singularity instance.stop インスタンス名
    $ bash start_container.sh
    $ singularity shell instance://インスタンス名
    > mysql_secure_installation
    > exit

rootユーザーのパスワードの設定等を行います。
"Enter current password for root (enter for none): "　では何も入力せずにEnterを押し、以降の質問には Y を入力すればよいです。

## MySQLデータベースの使用

mysqlコマンドを使用する場合は、singularity shell でinstance内に入るか、singularity exec で mysqlコマンドを実行します。
実行しているMySQL instanceのデータベースにアクセスする場合は、localhostのport で指定したポート番号にアクセスしてください。
