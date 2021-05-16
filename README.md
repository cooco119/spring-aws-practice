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

*커밋 단위가 아니라 작업일 단위로 기록됩니다*


## 발견한 문제

- lombok configuration

    - gradle 6.1.1 버전을 사용했는데, 책에 있는 대로 하면 `Variable xx not initialized in the default constructor` 문제가 발생한다.
      
    - gradle 5.x.x 버전 이후로는 build.gradle에 다음과 같은 설정이 추가로 필요하다
    
    > compileOnly('org.projectlombok:lombok')
    > annotationProcessor('org.projectlombok:lombok') // 추가 필요
  
    *(참조 : [블로그 아티클](https://deeplify.dev/back-end/spring/lombok-required-args-constructor-initialize-error#variable-not-initialized-in-the-default-constructor))*