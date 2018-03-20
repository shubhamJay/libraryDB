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

COPY Book_details from '/Users/sridevs/Desktop/libraryDB/Book_details.csv' with delimiter ',';
COPY books from '/Users/sridevs/Desktop/libraryDB/Books.csv' with delimiter ',';
