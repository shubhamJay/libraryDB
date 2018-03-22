create schema library;

set search_path to library;

create table books (book_id numeric(5) primary key, ISBN varchar(13),availability boolean default true);

create table Book_details (ISBN varchar(13) primary key, book_name varchar(40),
  Author varchar(40) not null default 'unknown', Publisher varchar(400) not null default 'unknown',
  description Text ,type varchar(20) not null
  );

create table users (user_id varchar(20) primary key,password varchar(20) not null, name varchar(40) not null,
contact_no numeric(10) not null, email_id varchar(40) not null);


create table transaction (transaction_id numeric(5) primary key, user_id varchar(20) references users(user_id) ,
book_id numeric(5) references books(book_id), borrowed_on date, returned_on date default null);

alter table books add constraint fk_to_books foreign key (ISBN) references Book_details(ISBN);

-----------------------------VIEWS---------------------------------------------
create view all_book_details as select b.book_id,b.availability,d.* from books b join book_details d
  on b.isbn = d.isbn;

create view count_of_book as select b.isbn,d.book_name, count(b.isbn)
  as number_of_book from books b join book_details d on b.isbn = d.isbn
  group by b.isbn, d.book_name;

create view detailed_transaction as select t.* ,(t.returned_on- t.borrowed_on)as bwd_duration_in_days, a.book_name,a.isbn
   from all_book_details a join
  transaction t on a.book_id = t.book_id;

create view untouched_books as select b.isbn,b.book_name from all_book_details b except select dt.isbn,dt.book_name from detailed_transaction dt where dt.isbn is not null;

create view all_transaction_of_before_june as select user_id,count(user_id)
  from detailed_transaction   where borrowed_on<'2017-06-30'
  and returned_on is null group by user_id;
-----------------------------functions-----------------------------------------

create or replace function get_number_of_copies (toSearch varchar) RETURNS bigint AS '
  select count(books.ISBN) from books where books.ISBN = toSearch
  '
  LANGUAGE SQL;

create or replace function get_transactions_in_given_month(monthNum integer, yearNum integer)
  returns table(transaction_id numeric,user_id varchar,book_id numeric,borrowed_on date,
    returned_on date,book_name varchar,isbn varchar) as $$

  select transaction_id,user_id,book_id,borrowed_on,returned_on,book_name,isbn from detailed_transaction where EXTRACT('month' from borrowed_on) = monthNum and
  EXTRACT('year' from borrowed_on) = yearNum;
  $$
 language SQL;

------------------------------END----------------------------------------------
\set path '\'':p'/Book_details.csv\''
COPY Book_details from :path with delimiter ',';

\set path '\'':p'/Books.csv\''
COPY books from :path with delimiter ',';

\set path '\'':p'/users.csv\''
COPY users from :path with delimiter ',';

\set path '\'':p'/transaction.csv\''
COPY transaction from :path with delimiter ',';
