# spring-aws-practice
[`스프링부트와 AWS로 혼자 구현하는 웹서비스`](http://m.yes24.com/Goods/Detail/83849117)
책을 빠르게 따라해보면서 spring boot에 익숙해지기 프로젝트

## 왜 하나요?

- Spring Boot 안써봤었는데 빠르게 경험해보기 위해
- 혼자 해보려 시도를 두세번 해봤으나, 돈을 안쓰니까 안하더라..

## 무엇을 얻고 싶나요?

- Spring Boot 조금 더 익숙해지기
- Intelij에 조금 더 익숙해지기
- RDB에 조금 더 익숙해지기 (평소에 NoSQL만 쓰던 자..)

## 작업 목록

*작업일 단위로 기록*

- 21.05.16 1장~5장 

  - 로컬에서 기본 기능 구현
    - Unit Tests
    - 기본 CRUD
    - 간단 프론트 w. mustache
    - 로그인 w. OAuth2
  
- 21.05.19 ~ 23

  - EC2 설정
  - RDS 설정
  - Docker 설정
  - dev, prod 용 application.properties 분리
  - docker repo를 이용한 배포 설정

## 발견한 문제

### lombok configuration

    - gradle 6.1.1 버전을 사용했는데, 책에 있는 대로 하면 `Variable xx not initialized in the default constructor` 문제가 발생한다.
      
    - gradle 5.x.x 버전 이후로는 build.gradle에 다음과 같은 설정이 추가로 필요하다
    
    > compileOnly('org.projectlombok:lombok')
    > annotationProcessor('org.projectlombok:lombok') // 추가 필요
  
    *(참조 : [블로그 아티클](https://deeplify.dev/back-end/spring/lombok-required-args-constructor-initialize-error#variable-not-initialized-in-the-default-constructor))*
  
### OpenJDK 14를 쓰니까 기존 설치되어있었던 gradle-6.1.1이 jdk14를 지원 안함
    
    > java.lang.NoClassDefFoundError: Could not initialize class org.codehaus.groovy.vmplugin.v7.Java7

#### Troubleshooting
- 그래서 gradle을 6.3으로 업그레이드 하니까 deprecated feature가 있다고 함
  > Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
- compile api가 deprecate됨 -> implementation으로 변경 ([참조](https://bluayer.com/13))
- 그래도 테스트가 깨짐. 로그를 제대로 보니 JUNIT이 뭔가 init을 못하고 있음
  > Caused by: org.springframework.core.NestedIOException at SimpleMetadataReader.java:57
  Caused by: java.lang.IllegalArgumentException at ClassReader.java:18
- Spring 버전, jdk 버전, gradle 버전의 상호 관계상 문제가 생길 수 있다는 말을 보고, spring을 기존 2.1.7 -> 2.2.13으로 업그레이드
- 이제 테스트는 도는데, posts 테이블이 없다는 에러가 나면서 모든 테스트 실패..
  > Caused by: org.h2.jdbc.JdbcSQLSyntaxErrorException: Table "POSTS" not found; SQL statement:
  insert into posts (created_date, modified_date, author, content, title) values (?, ?, ?, ?, ?) [42102-200]
- hibernate가 table을 못바꾸는것 같음
  > Hibernate: create table posts (id bigint not null auto_increment, created_date datetime, modified_date datetime, author varchar(255), content TEXT not null, title varchar(500) not null, primary key (id)) engine=MyISAM
  2021-05-21 17:41:24.725  WARN 38527 --- [    Test worker] o.h.t.s.i.ExceptionHandlerLoggedImpl     : GenerationTarget encountered exception accepting command : Error executing DDL "create table posts (id bigint not null auto_increment, created_date datetime, modified_date datetime, author varchar(255), content TEXT not null, title varchar(500) not null, primary key (id)) engine=MyISAM" via JDBC Statement

#### 결론 - hibernate 버전이 Spring Boot 2.1 -> 2.2로 바뀌면서 dialect 관련 설정 방법이 바뀐듯.

- test package의 application.properties에 db dialect를 h2용으로 설정하니 해결

> spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect

### EC2에 CodeDeploy 설치 시 문제 
> ruby가 없다고 함

- 참고 : https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html

### nginx 관련
### 책과 동일 명령어로 설치 안되는 이슈
>[ec2-user]$ sudo yum install nginx
> 
> Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
> 
> No package nginx available.
> 
> Error: Nothing to do
> 
> nginx is available in Amazon Linux Extra topic "nginx1"
> 
> To use, run
> 
> sudo amazon-linux-extras install nginx1
>
> Learn more at
https://aws.amazon.com/amazon-linux-2/faqs/#Amazon_Linux_Extras


- 다음 명령어 사용
    > sudo amazon-linux-extras install nginx1

### service nginx start 하면 `Starting nginx: [ OK ]` 노출 안됨
- `sudo systemctl status nginx.service`로 확인 필요
> Active: active (running) 항목이 있으면 성공



## 더 한 것

### Docker로 배포하기

  - dev와 prod 간의 application.properties를 다르게 가져가야 한다.
    - 참고 : https://velog.io/@harry-jang/SpringBoot-Gradle%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%98%EC%97%AC-profile%EB%B3%84-%ED%94%84%EB%A1%9C%ED%8D%BC%ED%8B%B0-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0
  
  - application-oauth.properties 파일 container 외부에서 주입하기
    - volume으로 config 파일 mount하고 env var로 해당 경로 지정 
    - dockerfile 참고
  
  - aws s3 대신 aws ecr에 이미지 푸시
    - docker build 와 aws ecr push용 .travis.yml 파일은 다음을 참고했다 (https://gist.github.com/BretFisher/14cd228f0d7e40dae085)
    - ECR은 IAM Policy에서 GetAuthrizationToken만 설정해주고, ECR 액션 관련 설정은 ECR에서 직접 해줘야 한다.
    > https://docs.aws.amazon.com/AmazonECR/latest/userguide/set-repository-policy.html

  - 무중단 배포 스크립트 작성 관련 추가 작업
    - 컨테이너 이름에다가 prod1 prod2를 넣고
    - stop.sh에서 해당 이름으로 컨테이너 스탑 및 삭제
    - start.sh에서는 해당 이름 및 포트로 컨테이너 시작해주도록 변경

  