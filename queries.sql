-- 1. Show the total titles available in the library.
select book_name from book_details;


-- 2)  Show the titles with highest number of copies.
select book_name,isbn from count_of_book where number_of_book = (select max(number_of_book) from count_of_book);


-- 3) Show the titles with five or less copies.
select * from count_of_book where number_of_book<5 order by number_of_book desc;


-- 4)Show the titles borrowed the most in a given month. (Eg: Sep 2017)
select book_name, count(book_name) as count1 from detailed_transaction
  where borrowed_on>'2017-06-01' and borrowed_on<'2017-07-01' group by book_name
  order by count(book_name) desc;


-- 5)Show the titles not borrowed for more than four months as of current date.
with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books
  except
  select distinct books_borrowed.ISBN from books_borrowed;


-- 6) Show the titles with more than 10 copies and not borrowed for the last 3 months.
with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books where getNumberOfCopies(books.ISBN) > 2
  except
  select distinct books_borrowed.ISBN from books_borrowed;


-- 7)Show the library user who borrowed the maximum books in a given period. (Eg: Jan 2018)
select user_id, count(user_id) from detailed_transaction
  where borrowed_on BETWEEN '2017-06-01' and '2017-07-01' group by user_id
  order by count(user_id) desc;


-- 8)Show the library user(s) who are in possession of a library book for more then 15 days.
select user_id,book_name from detailed_transaction
  where borrowed_on<'2017-06-30' and returned_on is null;


-- 9)Show the library user(s) who are in possession of more than two library books and holding atleast two of them for more then 15 days.
select * from all_transaction_of_before_june where count > 2;


-- 11)Show the titles that are in high demand and copies not available.
select * from detailed_transaction where bwd_duration_in_days <7;


-- 12) Show the average period of holding the borrowed books that were returned in a certain period. (Eg: Jan 2018).
select avg(bwd_duration_in_days) as average_of_datediff from detailed_transaction
    where borrowed_on>'2017-07-10' and borrowed_on<'2017-08-10';

 -- select * from (select d.user_id,b.book_id,b.book_name from all_book_details b join transaction d on b.book_id = d.book_id where d.borrowed_on>'2017-06-01' and d.borrowed_on<'2017-07-01') group by book_name
