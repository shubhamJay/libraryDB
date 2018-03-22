1) select book_name from book_details;

2) select book_name,isbn from count_of_book where number_of_book = (select max(number_of_book) from count_of_book);

3)select * from count_of_book where number_of_book<5 order by number_of_book desc;

4) select book_name, count(book_name) as count1 from detailed_transaction
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by book_name
  order by count(book_name) desc;

5) with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books
  except
  select distinct books_borrowed.ISBN from books_borrowed;

6) with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books where getNumberOfCopies(books.ISBN) > 2
  except
  select distinct books_borrowed.ISBN from books_borrowed;

7) select user_id, count(user_id) from detailed_transaction
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by user_id
  order by count(user_id) desc;

8)select user_id,book_name from detailed_transaction
  where borrowed_on<'2017-06-30' and returned_on is null;

9)-select * from all_transaction_of_before_june where count > 2;

11)- select * from detailed_transaction where bwd_duration_in_days <7;

12)-select avg(bwd_duration_in_days) as average_of_datediff from detailed_transaction
    where borrowed_on>'2017-07-10' and borrowed_on<'2017-08-10';

 -- select * from (select d.user_id,b.book_id,b.book_name from all_book_details b join transaction d on b.book_id = d.book_id where d.borrowed_on>'2017-06-01' and d.borrowed_on<'2017-07-01') group by book_name
