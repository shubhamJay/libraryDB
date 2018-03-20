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
  book_id numeric(5) references books(book_id), borrowed_on date, returned_on date);



alter table books add constraint fk_to_books foreign key (ISBN) references Book_details(ISBN);

-----------------------------VIEWS---------------------------------------------
create view all_book_details as select b.book_id,b.availability,d.* from books b join book_details d
  on b.isbn = d.isbn;

create view count_of_book as select b.isbn, count(b.isbn)
  as number_of_book from books b join book_details d on b.isbn = d.isbn
  group by b.isbn;

create view transaction_with_book_and_user_id as select t.* , a.book_name
  from all_book_details a join transaction t on a.book_id = t.book_id;

create view transaction_with_all_book as select t.* , a.book_name
  from all_book_details a left join transaction t on a.book_id = t.book_id;   
------------------------------END----------------------------------------------
\set path '\'':p'/Book_details.csv\''
COPY Book_details from :path with delimiter ',';

\set path '\'':p'/Books.csv\''
COPY books from :path with delimiter ',';

\set path '\'':p'/users.csv\''
COPY users from :path with delimiter ',';

\set path '\'':p'/transaction.csv\''
COPY transaction from :path with delimiter ',';
