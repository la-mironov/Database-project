------------- ТАБЛИЦА library – Библиотека
CREATE TABLE library (
lib_id character(6) NOT NULL,
name character(20));
COMMENT ON TABLE library IS 'Библиотека';
COMMENT ON COLUMN library.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN library.name IS 'Название библиотеки';
ALTER TABLE ONLY library ADD CONSTRAINT library_pkey PRIMARY KEY (lib_id);
------------- ТАБЛИЦА requis_lib – Расчётные счета библиотек
CREATE TABLE requis_lib (
lib_id character(6) REFERENCES library(lib_id) NOT NULL,
checking_account character(20) NOT NULL,
ogrn character(13),
inn character(12),
kpp character(9),
bik character(9),
street character(20) NOT NULL,
house character(5) NOT NULL);
COMMENT ON TABLE requis_lib IS 'Расчётные счета библиотек';
COMMENT ON COLUMN requis_lib.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN requis_lib.ogrn IS 'Основной государственный регистрационный номер';
COMMENT ON COLUMN requis_lib.inn IS 'Идентификационный номер налогоплательщика';
COMMENT ON COLUMN requis_lib.kpp IS 'Код причины постановки на учет';
COMMENT ON COLUMN requis_lib.bik IS 'Банковский идентификационный код';
COMMENT ON COLUMN requis_lib.street IS 'Название улицы';
COMMENT ON COLUMN requis_lib.house IS 'Номер дома';
COMMENT ON COLUMN requis_lib.checking_account IS 'Номер расчетного счета';
ALTER TABLE ONLY requis_lib ADD CONSTRAINT requis_lib_pkey PRIMARY KEY (lib_id);
------------- ТАБЛИЦА contacts_lib – Контактная информация о библиотеке
CREATE TABLE contacts_lib (
phone_number character(20) NOT NULL,
lib_id character(6) REFERENCES library(lib_id) NOT NULL);
COMMENT ON TABLE contacts_lib IS 'Контактная информация о библиотеке';
COMMENT ON COLUMN contacts_lib.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN contacts_lib.phone_number IS 'Номер телефона';
ALTER TABLE ONLY contacts_lib ADD CONSTRAINT contacts_lib_pkey PRIMARY KEY (phone_number);
------------- ТАБЛИЦА department_category – Категория отдела
CREATE TABLE department_category (
dep_categ_id character(6) NOT NULL,
name character(20));
COMMENT ON TABLE department_category IS 'Категория отдела';
COMMENT ON COLUMN department_category.dep_categ_id IS 'ID категории отдела';
COMMENT ON COLUMN department_category.name IS 'Название категории отдела';
ALTER TABLE ONLY department_category ADD CONSTRAINT department_category_pkey PRIMARY KEY (dep_categ_id);
------------- ТАБЛИЦА publication_category – Категория издания
CREATE TABLE publication_category (
publ_categ_id character(6) NOT NULL,
name character(20));
COMMENT ON TABLE publication_category IS 'Категория издания';
COMMENT ON COLUMN publication_category.publ_categ_id IS 'ID категории издания';
COMMENT ON COLUMN publication_category.name IS 'Название категории';
ALTER TABLE ONLY publication_category ADD CONSTRAINT publication_category_pkey PRIMARY KEY (publ_categ_id);
------------- ТАБЛИЦА publisher – Издатель
CREATE TABLE publisher (
publisher_id character(6) NOT NULL,
name character(20) NOT NULL,
country character(20));
COMMENT ON TABLE publisher IS 'Издатель';
COMMENT ON COLUMN publisher.publisher_id IS 'ID издателя';
COMMENT ON COLUMN publisher.name IS 'Название издателя';
ALTER TABLE ONLY publisher ADD CONSTRAINT publisher_pkey PRIMARY KEY (publisher_id);
------------- ТАБЛИЦА access_mode – Режим доступа
CREATE TABLE access_mode (
access_mode_id character(6) NOT NULL,
name character(20) NOT NULL,
access_period integer NOT NULL
CONSTRAINT access_period_not_negative CHECK ((access_period >= 0)));
COMMENT ON TABLE access_mode IS 'Режим доступа';
COMMENT ON COLUMN access_mode.access_mode_id IS 'ID режима доступа';
COMMENT ON COLUMN access_mode.access_period IS 'Допустимое количество дней в выдаче (если 0, то выдача доступна только в читательский зал)';
ALTER TABLE ONLY access_mode ADD CONSTRAINT access_mode_pkey PRIMARY KEY (access_mode_id);
------------- ТАБЛИЦА access_to_category – Связь категории издания с режимом доступа
CREATE TABLE access_to_category (
publ_categ_id character(6) REFERENCES publication_category(publ_categ_id) NOT NULL,
access_mode_id character(6) REFERENCES access_mode(access_mode_id) NOT NULL);
COMMENT ON TABLE access_to_category IS 'Связь категории издания с режимом доступа';
COMMENT ON COLUMN access_to_category.access_mode_id IS 'ID режима доступа';
COMMENT ON COLUMN access_to_category.publ_categ_id IS 'ID категории издания';
ALTER TABLE ONLY access_to_category ADD CONSTRAINT access_to_category_pkey PRIMARY KEY (publ_categ_id);
------------- ТАБЛИЦА author – Автор
CREATE TABLE author (
author_id character(6) NOT NULL,
first_name character(20) NOT NULL,
last_name character(20) NOT NULL,
fathers_name character(20),
country character(20));
COMMENT ON TABLE author IS 'Автор';
COMMENT ON COLUMN author.author_id IS 'ID автора';
COMMENT ON COLUMN author.first_name IS 'Имя автора';
COMMENT ON COLUMN author.last_name IS 'Фамилия автора';
COMMENT ON COLUMN author.fathers_name IS 'Отчество автора';
COMMENT ON COLUMN author.country IS 'Родина автора';
ALTER TABLE ONLY author ADD CONSTRAINT author_pkey PRIMARY KEY (author_id);
------------- ТАБЛИЦА publication – Издание
CREATE TABLE publication (
nomen_num character(6) NOT NULL,
publ_categ_id character(6) REFERENCES publication_category(publ_categ_id) NOT NULL,
author_id character(6) REFERENCES author(author_id) NOT NULL,
publisher_id character(6) REFERENCES publisher(publisher_id) NOT NULL,
name character(20) NOT NULL,
publ_year date,
pages_num integer
CONSTRAINT publication_pos_pages CHECK ((pages_num > 0)));
COMMENT ON TABLE publication IS 'Издание';
COMMENT ON COLUMN publication.nomen_num IS 'Номенклатурный номер';
COMMENT ON COLUMN publication.publ_categ_id IS 'ID категории издания';
COMMENT ON COLUMN publication.author_id IS 'ID автора';
COMMENT ON COLUMN publication.publisher_id IS 'ID издателя';
COMMENT ON COLUMN publication.name IS 'Название издания';
COMMENT ON COLUMN publication.publ_year IS 'Год издания';
COMMENT ON COLUMN publication.pages_num IS 'Объем в страницах';
ALTER TABLE ONLY publication ADD CONSTRAINT publication_pkey PRIMARY KEY (nomen_num);
------------- ТАБЛИЦА cancellation_publication – Списание издания
CREATE TABLE cancellation_publication (
cancelp_id character(6) NOT NULL,
lib_id character(6) REFERENCES library(lib_id) NOT NULL,
nomen_num character(10) REFERENCES publication(nomen_num) NOT NULL,
kol INTEGER,
date_cancel date
CONSTRAINT cancellation_publication_poskol CHECK ((kol > 0)));
COMMENT ON TABLE cancellation_publication IS 'Списание издания';
COMMENT ON COLUMN cancellation_publication.cancelp_id IS 'ID списания';
COMMENT ON COLUMN cancellation_publication.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN cancellation_publication.nomen_num IS 'Номенклатурный номер';
COMMENT ON COLUMN cancellation_publication.kol IS 'Количество списанных изданий';
COMMENT ON COLUMN cancellation_publication.date_cancel IS 'Дата списания';
ALTER TABLE ONLY cancellation_publication ADD CONSTRAINT cancellation_publication_pkey PRIMARY KEY (cancelp_id);
------------- ТАБЛИЦА composition – Произведение
CREATE TABLE composition (
comp_id character(6) NOT NULL,
author_id character(6) REFERENCES author(author_id) NOT NULL,
name character(20) NOT NULL,
date_wr date);
COMMENT ON TABLE composition IS 'Произведение';
COMMENT ON COLUMN composition.comp_id IS 'ID произведения';
COMMENT ON COLUMN composition.author_id IS 'ID автора произведения';
COMMENT ON COLUMN composition.name IS 'Название произведения';
COMMENT ON COLUMN composition.date IS 'Дата выпуска';
ALTER TABLE ONLY composition ADD CONSTRAINT composition_pkey PRIMARY KEY (comp_id);
------------- ТАБЛИЦА publication_to_composition – Включаемые произведения
CREATE TABLE publication_to_composition (
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL,
comp_id character(6) REFERENCES composition(comp_id) NOT NULL);
COMMENT ON TABLE publication_to_composition IS 'Включаемые произведения';
COMMENT ON COLUMN publication_to_composition.nomen_num IS 'Номенклатурный номер';
COMMENT ON COLUMN publication_to_composition.comp_id IS 'ID произведения';
ALTER TABLE ONLY publication_to_composition ADD CONSTRAINT publication_to_composition_pkey PRIMARY KEY (nomen_num, comp_id);
------------- ТАБЛИЦА dissertation – Диссертация
CREATE TABLE dissertation (
vak character(10) NOT NULL,
spec_cipher character(10) NOT NULL);
COMMENT ON TABLE dissertation IS 'Диссертация';
COMMENT ON COLUMN dissertation.vak IS 'Регистрационный номер ВАК';
COMMENT ON COLUMN dissertation.spec_cipher IS 'Шифр специальности';
ALTER TABLE ONLY dissertation ADD CONSTRAINT dissertation_pkey PRIMARY KEY (vak);
------------- ТАБЛИЦА magazine – Журнал
CREATE TABLE magazine (
issn character(10) NOT NULL,
genre character(20));
COMMENT ON TABLE magazine IS 'Журнал';
COMMENT ON COLUMN magazine.issn IS 'ISSN журнала';
COMMENT ON COLUMN magazine.genre IS 'Жанр';
ALTER TABLE ONLY magazine ADD CONSTRAINT magazine_pkey PRIMARY KEY (issn);
------------- ТАБЛИЦА handbook – Учебник
CREATE TABLE handbook (
isbn character(10) NOT NULL,
subject character(20),
grade integer);
COMMENT ON TABLE handbook IS 'Учебник';
COMMENT ON COLUMN handbook.isbn IS 'ISBN учебник';
COMMENT ON COLUMN handbook.subject IS 'Дисциплина';
COMMENT ON COLUMN handbook.grade IS 'Класс';
ALTER TABLE ONLY handbook ADD CONSTRAINT handbook_pkey PRIMARY KEY (isbn);
------------- ТАБЛИЦА book – Книга
CREATE TABLE book (
isbn character(10) NOT NULL,
genre character(20));
COMMENT ON TABLE book IS 'Книга';
COMMENT ON COLUMN book.isbn IS 'ISBN Книги';
COMMENT ON COLUMN book.genre IS 'Жанр';
ALTER TABLE ONLY book ADD CONSTRAINT book_pkey PRIMARY KEY (isbn);
------------- ТАБЛИЦА nomen_to_vak – Связь номенклатурного номера с регистрационным номером ВАК
CREATE TABLE nomen_to_vak (
vak character(6) REFERENCES dissertation(vak) NOT NULL,
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL);
COMMENT ON TABLE nomen_to_VAK IS 'Связь номенклатурного номера с регистрационным номером ВАК';
COMMENT ON COLUMN nomen_to_VAK.vak IS 'Регистрационный номер ВАК';
COMMENT ON COLUMN nomen_to_VAK.nomen_num IS 'Номенклатурный номер';
ALTER TABLE ONLY nomen_to_VAK ADD CONSTRAINT nomen_to_VAK_pkey PRIMARY KEY (nomen_num);
------------- ТАБЛИЦА nomen_to_issn – Связь номенклатурного номера с ISSN
CREATE TABLE nomen_to_issn (
issn character(6) REFERENCES magazine(issn) NOT NULL,
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL);
COMMENT ON TABLE nomen_to_issn IS 'Связь номенклатурного номера с ISSN';
COMMENT ON COLUMN nomen_to_issn.issn IS 'ISSN журнала';
COMMENT ON COLUMN nomen_to_issn.nomen_num IS 'Номенклатурный номер';
ALTER TABLE ONLY nomen_to_issn ADD CONSTRAINT nomen_to_issn_pkey PRIMARY KEY (nomen_num);
------------- ТАБЛИЦА nomen_to_isbn – Связь номенклатурного номера с ISBN
CREATE TABLE nomen_to_isbn (
isbn character(6) NOT NULL,
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL,
FOREIGN KEY (isbn) REFERENCES handbook(isbn) DEFERRABLE INITIALLY DEFERRED,
FOREIGN KEY (isbn) REFERENCES book(isbn) DEFERRABLE INITIALLY DEFERRED);
COMMENT ON TABLE nomen_to_isbn IS 'Связь номенклатурного номера с ISBN';
COMMENT ON COLUMN nomen_to_isbn.isbn IS 'ISBN кнгиг или учебника';
COMMENT ON COLUMN nomen_to_isbn.nomen_num IS 'Номенклатурный номер';
ALTER TABLE ONLY nomen_to_isbn ADD CONSTRAINT nomen_to_isbn_pkey PRIMARY KEY (nomen_num);
------------- ТАБЛИЦА suppliers – Поставщики
CREATE TABLE suppliers (
supp_id character(6) NOT NULL,
name character(20),
type_supp character(10));
COMMENT ON TABLE suppliers IS 'Поставщики';
COMMENT ON COLUMN suppliers.supp_id IS 'ID поставщика';
COMMENT ON COLUMN suppliers.name IS 'Название поставщика';
COMMENT ON COLUMN suppliers.type_supp IS 'Тип предприятия';
ALTER TABLE ONLY suppliers ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supp_id);
------------- ТАБЛИЦА requis_supp – Реквизиты поставщиков
CREATE TABLE requis_supp (
checking_account character(20) NOT NULL,
supp_id character(6) REFERENCES suppliers(supp_id) NOT NULL,
ogrn character(13),
inn character(12),
kpp character(9),
bik character(9),
city character(20),
street character(20),
house character(5));
COMMENT ON TABLE requis_supp IS 'Реквизиты поставщиков';
COMMENT ON COLUMN requis_supp.checking_account IS 'Номер расчетного счета';
COMMENT ON COLUMN requis_supp.supp_id IS 'ID поставщика';
COMMENT ON COLUMN requis_supp.ogrn IS 'Основной государственный регистрационный номер';
COMMENT ON COLUMN requis_supp.inn IS 'Идентификационный номер налогоплательщика';
COMMENT ON COLUMN requis_supp.kpp IS 'Код причины постановки на учет';
COMMENT ON COLUMN requis_supp.bik IS 'Банковский идентификационный код';
COMMENT ON COLUMN requis_supp.city IS 'Город поставщика';
COMMENT ON COLUMN requis_supp.street IS 'Название улицы';
COMMENT ON COLUMN requis_supp.house IS 'Номер дома';
ALTER TABLE ONLY requis_supp ADD CONSTRAINT requis_supp_pkey PRIMARY KEY (supp_id);
------------- ТАБЛИЦА contract – Договор
CREATE TABLE contract (
contr_id character(6) NOT NULL,
lib_id character(6) REFERENCES library(lib_id) NOT NULL,
supp_id character(6) REFERENCES suppliers(supp_id) NOT NULL,
date_sign date);
COMMENT ON TABLE contract IS 'Договор';
COMMENT ON COLUMN contract.contr_id IS 'ID договора';
COMMENT ON COLUMN contract.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN contract.supp_id IS 'ID поставщика';
COMMENT ON COLUMN contract.date_sign IS 'Дата заключения договора';
ALTER TABLE ONLY contract ADD CONSTRAINT contract_pkey PRIMARY KEY (contr_id);
------------- ТАБЛИЦА delivery_publ – Поставка издания
CREATE TABLE delivery_publ (
del_id character(6) NOT NULL,
contr_id character(6) NOT NULL,
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL,
kol integer,
date_deliv date
CONSTRAINT pos_kol CHECK ((kol > 0)));
COMMENT ON TABLE delivery_publ IS 'Поставка издания';
COMMENT ON COLUMN delivery_publ.move_id IS 'ID движения';
COMMENT ON COLUMN delivery_publ.contr_id IS 'ID договора';
COMMENT ON COLUMN delivery_publ.nomen_num IS 'Номенклатурный номер';
COMMENT ON COLUMN delivery_publ.kol IS 'Количество изделий в поставке';
COMMENT ON COLUMN delivery_publ.date_deliv IS 'Дата поставки';
ALTER TABLE ONLY delivery_publ ADD CONSTRAINT delivery_publ_pkey PRIMARY KEY (del_id);
------------- ТАБЛИЦА human – Человек
CREATE TABLE human (
human_id character(6) NOT NULL,
first_name character(20) NOT NULL,
last_name character(20) NOT NULL,
fathers_name character(20),
gender character(20));
COMMENT ON TABLE human IS 'Человек';
COMMENT ON COLUMN human.human_id IS 'ID человека';
COMMENT ON COLUMN human.first_name IS 'Имя';
COMMENT ON COLUMN human.last_name IS 'Фамилия';
COMMENT ON COLUMN human.fathers_name IS 'Отчество';
COMMENT ON COLUMN human.gender IS 'Пол';
ALTER TABLE ONLY human ADD CONSTRAINT human_pkey PRIMARY KEY (human_id);
------------- ТАБЛИЦА addres_reg – Адрес регистрации
CREATE TABLE addres_reg (
addres_reg_id character(6) NOT NULL,
city character(20) NOT NULL,
street character(20) NOT NULL,
house character(10) NOT NULL,
flat character(10));
COMMENT ON TABLE addres_reg IS 'Адрес регистрации';
COMMENT ON COLUMN addres_reg.addres_reg_id IS 'ID адреса регистрации';
COMMENT ON COLUMN addres_reg.city IS 'Город';
COMMENT ON COLUMN addres_reg.street IS 'Улица';
COMMENT ON COLUMN addres_reg.house IS 'Дом';
COMMENT ON COLUMN addres_reg.flat IS 'Квартира(при наличии)';
ALTER TABLE ONLY addres_reg ADD CONSTRAINT addres_reg_pkey PRIMARY KEY (addres_reg_id);
------------- ТАБЛИЦА passport – Паспорт
CREATE TABLE passport (
human_id character(6) REFERENCES human(human_id) NOT NULL,
series character(10) NOT NULL,
num integer NOT NULL,
addres_reg_id character(6) REFERENCES addres_reg(addres_reg_id) NOT NULL,
date_iss date);
COMMENT ON TABLE passport IS 'Паспорт';
COMMENT ON COLUMN passport.human_id IS 'ID человека';
COMMENT ON COLUMN passport.series IS 'Серия паспорта';
COMMENT ON COLUMN passport.num IS 'Номер паспорта';
COMMENT ON COLUMN passport.addres_reg_id IS 'ID адреса регистрации';
COMMENT ON COLUMN passport.date_iss IS 'Дата выдачи';
ALTER TABLE ONLY passport ADD CONSTRAINT passport_pkey PRIMARY KEY (human_id);
ALTER TABLE ONLY passport ADD CONSTRAINT passport_unique UNIQUE (series, num);
------------- ТАБЛИЦА human_contacts – Контактная информация о человеке
CREATE TABLE human_contacts (
cont_id character(6) NOT NULL,
human_id character(6) REFERENCES human(human_id) NOT NULL,
phone_num character(20) NOT NULL);
COMMENT ON TABLE human_contacts IS 'Контактная информация о человеке';
COMMENT ON COLUMN human_contacts.cont_id IS 'ID контакта';
COMMENT ON COLUMN human_contacts.human_id IS 'ID человека';
COMMENT ON COLUMN human_contacts.phone_num IS 'Номер телефона';
ALTER TABLE ONLY human_contacts ADD CONSTRAINT human_contacts_pkey PRIMARY KEY (cont_id);
------------- ТАБЛИЦА post – Должность
CREATE TABLE post (
post_id character(6) NOT NULL,
name character(20) NOT NULL);
COMMENT ON TABLE post IS 'Должность';
COMMENT ON COLUMN post.post_id IS 'ID должности';
COMMENT ON COLUMN post.name IS 'Название должности';
ALTER TABLE ONLY post ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);
------------- ТАБЛИЦА salary – Зарплата
CREATE TABLE salary (
post_id character(6) REFERENCES post(post_id) NOT NULL,
salary_val integer NOT NULL);
COMMENT ON TABLE salary IS 'Зарплата';
COMMENT ON COLUMN salary.post_id IS 'ID должности';
COMMENT ON COLUMN salary.salary_val IS 'Размер зарплаты';
ALTER TABLE ONLY salary ADD CONSTRAINT salary_pkey PRIMARY KEY (post_id);
------------- ТАБЛИЦА employee – Сотрудник
CREATE TABLE employee (
emp_id character(6) REFERENCES human(human_id) NOT NULL,
post_id character(6) REFERENCES post(post_id) NOT NULL);
COMMENT ON TABLE employee IS 'Сотрудник';
COMMENT ON COLUMN employee.emp_id IS 'ID сотрудника';
COMMENT ON COLUMN employee.post_id IS 'ID должности';
ALTER TABLE ONLY employee ADD CONSTRAINT employee_pkey PRIMARY KEY (emp_id);
------------- ТАБЛИЦА department – Отдел
CREATE TABLE department (
dep_id character(6) NOT NULL,
lib_id character(6) REFERENCES library(lib_id) NOT NULL,
manager_id character(6) REFERENCES employee(emp_id) NOT NULL,
dep_categ_id character(6) REFERENCES department_category(dep_categ_id) NOT NULL);
COMMENT ON TABLE department IS 'Отдел';
COMMENT ON COLUMN department.dep_id IS 'ID отдела';
COMMENT ON COLUMN department.lib_id IS 'ID библиотеки';
COMMENT ON COLUMN department.manager_id IS 'ID управляющего';
COMMENT ON COLUMN department.dep_categ_id IS 'ID категории отдела';
ALTER TABLE ONLY department ADD CONSTRAINT department_pkey PRIMARY KEY (dep_id);
ALTER TABLE employee ADD dep_id character(6) REFERENCES department(dep_id) NOT NULL;
COMMENT ON COLUMN employee.dep_id IS 'ID отдела';
------------- ТАБЛИЦА reading_room – Читательный зал
CREATE TABLE reading_room (
rroom_id character(6) NOT NULL,
dep_id character(6) REFERENCES department(dep_id) NOT NULL,
manager_id character(6) REFERENCES employee(emp_id) NOT NULL,
room_num INTEGER NOT NULL);
COMMENT ON TABLE reading_room IS 'Читательский зал';
COMMENT ON COLUMN reading_room.rroom_id IS 'ID зала';
COMMENT ON COLUMN reading_room.dep_id IS 'ID отдела';
COMMENT ON COLUMN reading_room.manager_id IS 'ID заведующего';
COMMENT ON COLUMN reading_room.room_num IS 'Номер читательского зала';
ALTER TABLE ONLY reading_room ADD CONSTRAINT reading_room_pkey PRIMARY KEY (rroom_id);
------------- ТАБЛИЦА candidate – Кандидат на работу
CREATE TABLE candidate (
cand_id character(6) REFERENCES human(human_id) NOT NULL,
dep_id character(6) REFERENCES department(dep_id) NOT NULL,
post_id character(6) REFERENCES post(post_id) NOT NULL);
COMMENT ON TABLE candidate IS 'Кандидат на работу';
COMMENT ON COLUMN candidate.cand_id IS 'ID кандидата';
COMMENT ON COLUMN candidate.dep_id IS 'ID отдела кадров';
COMMENT ON COLUMN candidate.post_id IS 'ID должности';
ALTER TABLE ONLY candidate ADD CONSTRAINT candidate_pkey PRIMARY KEY (cand_id);
------------- ТАБЛИЦА instance – Экземпляр издания
CREATE TABLE instance (
inst_id character(6) NOT NULL,
nomen_num character(6) REFERENCES publication(nomen_num) NOT NULL,
rroom_id character(6) REFERENCES reading_room(rroom_id) NOT NULL,
shelv integer NOT NULL);
COMMENT ON TABLE instance IS 'Экземпляр издания';
COMMENT ON COLUMN instance.inst_id IS 'ID экземпляра издания';
COMMENT ON COLUMN instance.nomen_num IS 'Номенклатурный номер издания';
COMMENT ON COLUMN instance.rroom_id IS 'ID читательского зала, где хранится экземпляр';
COMMENT ON COLUMN instance.shelv IS 'Стеллаж';
ALTER TABLE ONLY instance ADD CONSTRAINT instance_pkey PRIMARY KEY (inst_id);
------------- ТАБЛИЦА librarian_service – библиотекарь отдела обслуживания
CREATE TABLE librarian_service (
libserv_id character(6) REFERENCES employee(emp_id) NOT NULL,
rroom_id character(6) REFERENCES reading_room(rroom_id) NOT NULL);
COMMENT ON TABLE librarian_service IS 'Библиотекарь отдела обслуживания';
COMMENT ON COLUMN librarian_service.libserv_id IS 'ID библиотекаря';
COMMENT ON COLUMN librarian_service.rroom_id IS 'ID читательского зала, где работает библиотекарь';
ALTER TABLE ONLY librarian_service ADD CONSTRAINT librarian_service_pkey PRIMARY KEY (libserv_id);
------------- ТАБЛИЦА visitor_category – Категория читателя
CREATE TABLE visitor_category (
viscat_id character(6) NOT NULL,
name character(20) NOT NULL);
COMMENT ON TABLE visitor_category IS 'Категория читателя';
COMMENT ON COLUMN visitor_category.viscat_id IS 'ID категории читателя';
COMMENT ON COLUMN visitor_category.name IS 'Название категории читателя';
ALTER TABLE ONLY visitor_category ADD CONSTRAINT visitor_category_pkey PRIMARY KEY (viscat_id);
------------- ТАБЛИЦА visitor– Читатель
CREATE TABLE visitor(
vis_id character(6) NOT NULL,
viscat_id character(6) REFERENCES visitor_category(viscat_id) NOT NULL,
lib_id character(6) REFERENCES library(lib_id) NOT NULL,
date_reg date NOT NULL DEFAULT NOW());
COMMENT ON TABLE visitor IS 'Читатель';
COMMENT ON COLUMN visitor.vis_id IS 'ID читателя';
COMMENT ON COLUMN visitor.viscat_id IS 'ID категории читателя';
COMMENT ON COLUMN visitor.lib_id IS 'ID библиотеки, к которой относится читатель';
COMMENT ON COLUMN visitor.date_reg IS 'Дата регистрации';
ALTER TABLE ONLY visitor ADD CONSTRAINT visitor_pkey PRIMARY KEY (vis_id);
------------- ТАБЛИЦА visit_track – Учёт посещений
CREATE TABLE visit_track (
vistr_id character(6) NOT NULL,
vis_id character(6) REFERENCES visitor(vis_id) NOT NULL,
libserv_id character(6) REFERENCES librarian_service(libserv_id) NOT NULL,
date_visit date DEFAULT NOW() NOT NULL);
COMMENT ON TABLE visit_track IS 'Учёт посещений';
COMMENT ON COLUMN visit_track.vistr_id IS 'ID посещения';
COMMENT ON COLUMN visit_track.vis_id IS 'ID читателя';
COMMENT ON COLUMN visit_track.libserv_id IS 'ID библиотекаря';
COMMENT ON COLUMN visit_track.date_visit IS 'Дата посещения';
ALTER TABLE ONLY visit_track ADD CONSTRAINT visit_track_pkey PRIMARY KEY (vistr_id);
------------- ТАБЛИЦА issuance – ВЫдача экземпляра
CREATE TABLE issuance (
iss_id character(6) NOT NULL,
vis_id character(6) REFERENCES visitor(vis_id) NOT NULL,
libserv_id character(6) REFERENCES librarian_service(libserv_id) NOT NULL,
inst_id character(6) REFERENCES instance(inst_id) NOT NULL,
date_iss date DEFAULT NOW() NOT NULL);
COMMENT ON TABLE issuance IS 'ВЫдача экземпляра';
COMMENT ON COLUMN issuance.vis_id IS 'ID читателя';
COMMENT ON COLUMN issuance.libserv_id IS 'ID библиотекаря';
COMMENT ON COLUMN issuance.inst_id IS 'ID экземпляра';
COMMENT ON COLUMN issuance.date_iss IS 'Дата выдачи';
ALTER TABLE ONLY issuance ADD CONSTRAINT issuance_pkey PRIMARY KEY (iss_id);
------------- ТАБЛИЦА return_book – Возврат экземпляра
CREATE TABLE return_book (
iss_id character(6) REFERENCES issuance(iss_id) NOT NULL,
date_ret date DEFAULT NOW() NOT NULL);
COMMENT ON TABLE return_book IS 'Возврат экземпляра';
COMMENT ON COLUMN return_book.iss_id IS 'ID выдачи';
COMMENT ON COLUMN return_book.date_ret IS 'Дата возврата';
ALTER TABLE ONLY return_book ADD CONSTRAINT return_book_pkey PRIMARY KEY (iss_id);
------------- ТАБЛИЦА student – Студент
CREATE TABLE student (
vis_id character(6) REFERENCES visitor(vis_id) NOT NULL,
col_name character(20),
faculty character(20),
date_add date,
group_n character(10));
COMMENT ON TABLE student IS 'Студент';
COMMENT ON COLUMN student.vis_id IS 'ID читателя';
COMMENT ON COLUMN student.col_name IS 'Название ВУЗа';
COMMENT ON COLUMN student.faculty IS 'Факультет';
COMMENT ON COLUMN student.date_add IS 'Дата зачисления';
COMMENT ON COLUMN student.group_n IS 'Номер группы';
ALTER TABLE ONLY student ADD CONSTRAINT student_pkey PRIMARY KEY (vis_id);
------------- ТАБЛИЦА researcher – Научный работник
CREATE TABLE researcher (
vis_id character(6) REFERENCES visitor(vis_id) NOT NULL,
org_name character(20),
res_topic character(20));
COMMENT ON TABLE researcher IS 'Научный работник';
COMMENT ON COLUMN researcher.vis_id IS 'ID читателя';
COMMENT ON COLUMN researcher.org_name IS 'Название организации';
COMMENT ON COLUMN researcher.res_topic IS 'Научная тема';
ALTER TABLE ONLY researcher ADD CONSTRAINT researcher_pkey PRIMARY KEY (vis_id);
------------- ТАБЛИЦА schoolboy – Школьник
CREATE TABLE schoolboy (
vis_id character(6) REFERENCES visitor(vis_id) NOT NULL,
sch_name character(20),
date_add date);
COMMENT ON TABLE schoolboy IS 'Школьник';
COMMENT ON COLUMN schoolboy.vis_id IS 'ID читателя';
COMMENT ON COLUMN schoolboy.sch_name IS 'Название школы';
COMMENT ON COLUMN schoolboy.date_add IS 'Дата зачисления';
ALTER TABLE ONLY schoolboy ADD CONSTRAINT schoolboy_pkey PRIMARY KEY (vis_id);
------------- ТАБЛИЦА employee_move – Движения сотрудников
CREATE TABLE employee_move (
move_id character(6) NOT NULL,
human_id character(6) REFERENCES human(human_id) NOT NULL,
post_id character(6) REFERENCES post(post_id) NOT NULL,
dep_id character(6) REFERENCES department(dep_id) NOT NULL,
date_add date NOT NULL,
date_rem date NOT NULL);
COMMENT ON TABLE employee_move IS 'Движения сотрудников';
COMMENT ON COLUMN employee_move.move_id IS 'ID движения';
COMMENT ON COLUMN employee_move.human_id IS 'ID человека';
COMMENT ON COLUMN employee_move.post_id IS 'ID должности';
COMMENT ON COLUMN employee_move.dep_id IS 'ID отдела';
COMMENT ON COLUMN employee_move.date_add IS 'Дата вступления в должность';
COMMENT ON COLUMN employee_move.date_rem IS 'Дата выхода из должности';
ALTER TABLE ONLY employee_move ADD CONSTRAINT employee_move_pkey PRIMARY KEY (move_id);