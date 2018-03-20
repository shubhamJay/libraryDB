
create view all_book_details as select b.book_id,b.availability,d.* from books b join book_details d
  on b.isbn = d.isbn;

1 - select * from  all_book_details where availability = false;

create view count_of_book as select b.isbn, count(b.isbn)
  as number_of_book from books b join book_details d on b.isbn = d.isbn
  group by b.isbn;


2) select * from count_of_book order by number_of_book desc;

3) select * from count_of_book where number_of_book > 5;

create view transaction_with_book_and_user_id as select t.* , a.book_name
  from all_book_details a join transaction t on a.book_id = t.book_id;


4) select book_name, count(book_name) as count1 from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by book_name
  order by count(book_name) desc;


7) select user_id, count(user_id) from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by user_id
  order by count(user_id) desc limit 1;



 -- select * from (select d.user_id,b.book_id,b.book_name from all_book_details b join transaction d on b.book_id = d.book_id where d.borrowed_on>'2017-06-01' and d.borrowed_on<'2017-07-01') group by book_name
