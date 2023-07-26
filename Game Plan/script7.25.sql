create table citymap
(
    id                bigint      not null
        primary key,
    name              varchar(50) not null,
    prosperity        bigint      not null,
    gold              bigint      not null,
    constructionSpeed int         not null,
    constraint CityMap_id_uindex
        unique (id)
);

create table takenmapcell
(
    mapId      bigint not null,
    positionX  int    not null,
    positionY  int    not null,
    houseType  int    not null,
    buildTime  int    null,
    primary key (mapId, positionX, positionY)
);

create table user
(
    id         bigint auto_increment     primary key,
    email      varchar(256) not null,
    password   varchar(256) not null,
    avatar     BLOB   null,
    name       varchar(50)  not null,
    cityMap    bigint  null,
    isActive   tinyint      not null comment '0-not actived 1-actived',
    activeCode varchar(50)  null,
    loginTime  datetime     null,
    logoutTime datetime     null,
    constraint User_email_uindex
        unique (email),
    constraint User_id_uindex
        unique (id)
);

create table user_quiz
(
    id          bigint not null,
    quizId      int    not null,
    knowledgeId int    not null,
    attempts    int    null,
    topScore    int    null,
    primary key (id, quizId, knowledgeId)
);

