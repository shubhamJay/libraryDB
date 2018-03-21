1) select book_name from book_details;

2) select book_name,isbn from count_of_book where number_of_book = (select max(number_of_book) from count_of_book);

3)select * from count_of_book where number_of_book<5 order by number_of_book desc;

4) select book_name, count(book_name) as count1 from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by book_name
  order by count(book_name) desc;

5) select distinct book_name from transaction_with_all_book where returned_on-borrowed_on>120 or transaction_id is null;

7) select user_id, count(user_id) from transaction_with_book_and_user_id
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by user_id
  order by count(user_id) desc;

8)-select user_id,book_name from transaction_with_book_and_user_id
  where borrowed_on<'2017-06-20' and returned_on is null;


9)-select * from all_transaction_of_before_june where count > 2;

11)- select * from transaction_with_book_and_user_id where daydiff <7;

12)-select avg(daydiff) as average_of_datediff from transaction_with_book_and_user_id
    where borrowed_on>'2017-07-10' and borrowed_on<'2017-08-10';

 -- select * from (select d.user_id,b.book_id,b.book_name from all_book_details b join transaction d on b.book_id = d.book_id where d.borrowed_on>'2017-06-01' and d.borrowed_on<'2017-07-01') group by book_name
