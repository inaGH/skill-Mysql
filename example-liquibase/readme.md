# 数据库版本管理工具Liquibase社区版本

## 一、项目中使用
### 1.依赖引入
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-liquibase</artifactId>
</dependency>
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```
### 2.Changelog定义
#### 2.1 Changelog主文件：/db/changelog/db.changelog-master.yaml
```yaml
databaseChangeLog:
  - include:
      file: db/changelog/p1-base.sql
  - include:
      file: db/changelog/p2-table.sql
  - include:
      file: db/changelog/p3-data.sql
```
#### 2.2 基础表结构示例：/db/changelog/p1-base.sql
```sql
--liquibase formatted sql

--changeset your.name:base-1 labels:example-label context:example-context
--comment: example comment
create table person (
                        id int primary key auto_increment not null,
                        name varchar(50) not null,
                        address1 varchar(50),
                        address2 varchar(50),
                        city varchar(30)
)
--rollback DROP TABLE person;

--changeset your.name:base-2 labels:example-label context:example-context
--comment: example comment
create table company (
                         id int primary key auto_increment not null,
                         name varchar(50) not null,
                         address1 varchar(50),
                         address2 varchar(50),
                         city varchar(30)
)
--rollback DROP TABLE company;
```
#### 2.3 表结构变更文件示例：/db/changelog/p2-table.sql
```sql
--liquibase formatted sql

--changeset other.dev:table-1 labels:example-label context:example-context
--comment: example comment
alter table person add column country varchar(2)
--rollback ALTER TABLE person DROP COLUMN country;
```
#### 2.4 表数据变更文件示例：/db/changelog/p3-data.sql
```sql
--liquibase formatted sql

--changeset other.dev:data-1 labels:example-label context:example-context
--comment: example comment
INSERT INTO `test`.`company` (`id`, `name`, `address1`, `address2`, `city`) VALUES (1, '企业', '滨江', '余杭', '杭州')
--rollback delete from `test`.`company` where id=1;
```
### 3.初始化
#### 3.1 spring boot 4.x只需引入spring-boot-starter-liquibase依赖后配置数据库参数即可
#### 3.2 spring boot 4.x以前的版本，可结合引入spring-boot-autoconfigure和liquibase-core
#### 3.3 更老的springMVC项目（自定义启动配置）
```java
package com.example.config;
import liquibase.integration.spring.SpringLiquibase;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import javax.sql.DataSource;
@Configuration
public class LiquibaseConfig {
    @Bean
    public SpringLiquibase liquibase(@Qualifier("dataSource") DataSource dataSource) {
        SpringLiquibase liquibase = new SpringLiquibase();
        // 数据源
        liquibase.setDataSource(dataSource);
        // 脚本路径
        liquibase.setChangeLog("classpath:/db/changelog/db.changelog-master.yaml");
        return liquibase;
    }
}
```

### 4.程序启动时执行变更（防止忘记执行某个生产环境的结构或字段出现问题）
```shell
mvn clean package
java -jar target/example-liquibase.jar
```

### 5.maven plugin命令（出现问题时临时处理万能工具箱）
```shell
# 环境变量配置
## windows（一般需要重启IDE生效）
setx MYSQL_HOST "mysql"
setx MYSQL_PORT "3306"
setx MYSQL_SCHEMA "test"
setx MYSQL_USERNAME "root"
setx MYSQL_PASSWORD "root"
## Linux
export MYSQL_HOST=mysql
export MYSQL_PORT=3306
export MYSQL_SCHEMA=test
export MYSQL_USERNAME=root
export MYSQL_PASSWORD=root


# 状态查看
mvn liquibase:status
# 打tag
mvn liquibase:tag -Dliquibase.tag=v1.0
# 打tag
mvn liquibase:tagExists -Dliquibase.tag=v1.0
# 按tag回滚
mvn liquibase:rollback -Dliquibase.rollbackTag=v1.0
# 回滚最新1次变更
mvn liquibase:rollback -Dliquibase.rollbackCount=1
# 回滚到指定日期（YYYY-MM-DD, rollback-to-date HH:MM:SS, or rollback-to-date YYYY-MM-DD’T’HH:MM:SS）
mvn liquibase:rollback -Dliquibase.rollbackDate=2026-02-08
```

## 二、命令行工具使用
### 1.下载所需程序
[Liquibase-cli](https://www.liquibase.com/download-community)
[MySQL-Connector](https://dev.mysql.com/downloads/connector/j/)

### 2.基础库表初始脚本生成
```shell
liquibase --driver=com.mysql.cj.jdbc.Driver --classpath=mysql-connector-j.jar --changeLogFile=./initialize/database.mysql.sql --url="jdbc:mysql://mysql:3306/test" --username=root --password=root generateChangeLog
```
### 3.基础库数据初始脚本生成
```shell
liquibase --driver=com.mysql.cj.jdbc.Driver --classpath=mysql-connector-j.jar --changeLogFile=./initialize/database.mysql.sql --url="jdbc:mysql://mysql:3306/test" --username=root --password=root --diffTypes=data generateChangeLog
```

