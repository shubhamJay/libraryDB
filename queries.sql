
create view all_book_details as select b.book_id,b.availability,d.* from books b join book_details d
  on b.isbn = d.isbn;

1) - select * from  all_book_details where availability = false;

create view count_of_book as select b.isbn, count(b.isbn)
  as number_of_book from books b join book_details d on b.isbn = d.isbn
  group by b.isbn;


2) select * from count_of_book order by number_of_book desc;

3)select * from count_of_book where number_of_book<5 order by number_of_book desc;

create view transaction_with_book_and_user_id as select t.* , a.book_name,a.isbn,
TRUNC(DATE_PART('day', t.returned_on::timestamp - t.borrowed_on::timestamp)) as daydiff from all_book_details a join transaction t on a.book_id = t.book_id;


4) select book_name, count(book_name) as count1 from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by book_name
  order by count(book_name) desc;

create view transaction_with_all_book as select t.* , a.book_name
  from all_book_details a left join transaction t on a.book_id = t.book_id;

-- 5) select not book_name from transaction_with_all_book
--   where not borrowed_on>'2017-06-01';

7) select user_id, count(user_id) from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by user_id
  order by count(user_id) desc;

8)-select user_id,book_name from transaction_with_book_and_user_id
  where borrowed_on<'2017-06-20' and returned_on is null;

create view all_transaction_of_before_june as select user_id,count(user_id)
   from transaction_with_book_and_user_id   where borrowed_on<'2017-06-20'
   and returned_on is null group by user_id;

9)-select * from all_transaction_of_before_june where count > 2;

11)- select * from transaction_with_book_and_user_id where daydiff <7;

12)-select avg(daydiff) as average_of_datediff from transaction_with_book_and_user_id
    where borrowed_on>'2017-07-10' and borrowed_on<'2017-08-10';

 -- select * from (select d.user_id,b.book_id,b.book_name from all_book_details b join transaction d on b.book_id = d.book_id where d.borrowed_on>'2017-06-01' and d.borrowed_on<'2017-07-01') group by book_name
