create table priority (
    pri_id      int not null,
    pri_name    varchar(25) not null,
    pri_order   int unique not null,
    constraint  pk_priority primary key (pri_id)
);

create table severity (
    sev_id      int not null,
    sev_name    varchar(25) not null,
    sev_order   int unique not null,
    constraint  pk_severity primary key (sev_id)
);

create table sprint (
    spr_id          serial not null,
    spr_name        varchar(50) not null,
    spr_dateStart   date not null,
    spr_dateEnd     date null,
    spr_dateCreate  timestamp not null,
    constraint  pk_sprint primary key (spr_id)
);

create table state (
    sta_id      int not null,
    sta_name    varchar(25) not null,
    sta_order   int unique not null,
    constraint  pk_state primary key (sta_id)
);

create table tag (
    tag_id          serial not null,
    tag_name        varchar(50) not null,
    tag_color_rgb   varchar(10) null,
    constraint  pk_tag primary key (tag_id)
);

create table account (
    acc_id          serial not null,
    acc_pseudo      varchar(50) unique not null,
    acc_email       varchar(50) unique null,
    acc_password    bytea not null,
    constraint  pk_account primary key (acc_id)
);

create table project (
    prj_id          serial not null,
    prj_name        varchar(50) not null,
    prj_dateCreate  timestamp not null,
    prj_description varchar(250) null,
    constraint  pk_project primary key (prj_id)
);

create table member (
    acc_id              int not null,
    prj_id              int not null,
    mem_date_joined     timestamp not null,
    constraint pk_member            primary key (acc_id, prj_id),
    constraint fk_member_user       foreign key (acc_id)    references account(acc_id),
    constraint fk_member_project    foreign key (prj_id) references project(prj_id)
);

create table epic (
    epi_id          serial not null,
    epi_name        varchar(50) not null,
    epi_description varchar(250) null,
    epi_date_create timestamp not null,
    prj_id          int not null,
    constraint pk_epic          primary key (epi_id),
    constraint fk_epic_project  foreign key (prj_id) references project(prj_id)
);

create table user_story (
    ust_id          serial not null,
    ust_name        varchar(50) not null,
    ust_description varchar(250) null,
    ust_date_create timestamp not null,
    epi_id          int not null,
    constraint  pk_userstory        primary key (ust_id),
    constraint  fk_userstory_epic   foreign key (epi_id) references epic(epi_id)
);

create table task (
    tsk_id                  serial not null,
    tsk_name                varchar(50) not null,
    tsk_description         varchar(250) null,
    tsk_date_create         timestamp not null,
    tsk_date_start          date null,
    tsk_date_end            date null,
    tsk_nb_time_forecast    decimal null,
    tsk_nb_time_real        decimal null,
    tsk_is_bug              boolean default(false) not null,
    tsk_is_delete           boolean default(false) not null,
    tsk_date_delete         timestamp null,
    tsk_is_archive          boolean default(false) not null,
    tsk_date_archive        timestamp null,
    ust_id                  int not null,
    sta_id                  int not null,
    spr_id                  int null,
    sev_id                  int null,
    pri_id                  int not null,
    constraint  pk_task             primary key (tsk_id),
    constraint  fk_task_userstory   foreign key (ust_id)    references user_story(ust_id),
    constraint  fk_task_state       foreign key (sta_id)    references state(sta_id),
    constraint  fk_task_sprint      foreign key (spr_id)    references sprint(spr_id),
    constraint  fk_task_severity    foreign key (sev_id)    references severity(sev_id),
    constraint  fk_task_priority    foreign key (pri_id)    references priority(pri_id)
);

create table link_tag_task (
    tsk_id  int not null,
    tag_id  int not null,
    constraint pk_linktagtask       primary key (tsk_id, tag_id),
    constraint fk_linktagtask_tag   foreign key (tag_id)    references tag(tag_id),
    constraint fk_linktagtask_task  foreign key (tsk_id)    references task(tsk_id)
);

create table link_member_task (
    acc_id  int not null,
    prj_id  int not null,
    tsk_id  int not null,
    constraint  pk_linkmembertask           primary key (acc_id, prj_id, tsk_id),
    constraint  fk_linkmembertask_task      foreign key (tsk_id)         references task(tsk_id),
    constraint  fk_linkmembertask_member    foreign key (prj_id, acc_id) references member(prj_id, acc_id)
);

create table message (
    msg_id                  serial not null,
    msg_message             varchar(250) not null,
    msg_date_published      timestamp not null,
    msg_date_update         timestamp null,
    msg_is_delete           boolean default(false) not null,
    msg_date_delete         timestamp null,
    acc_id                  int not null,
    prj_id                  int not null,
    tsk_id                  int not null,
    constraint  pk_message          primary key (msg_id),
    constraint  fk_message_task     foreign key (tsk_id)            references task(tsk_id),
    constraint  fk_message_member   foreign key (acc_id, prj_id)    references member(acc_id, prj_id)
);
