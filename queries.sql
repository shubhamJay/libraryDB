-- 1. Show the total titles available in the library.
select book_name from book_details;

-- 2)  Show the titles with highest number of copies.
select book_name,isbn from count_of_book where number_of_book = (select max(number_of_book) from count_of_book);

-- 3) Show the titles with five or less copies.
select * from count_of_book where number_of_book<5 order by number_of_book desc;

-- 4)Show the titles borrowed the most in a given month. (Eg: Sep 2017)
select book_name, count(book_name) as count from get_transactions_in_given_month(6,2017)
  group by book_name order by count desc;

-- 5)Show the titles not borrowed for more than four months as of current date.
with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books
  except
  select distinct books_borrowed.ISBN from books_borrowed;

-- 6) Show the titles with more than 10 copies and not borrowed for the last 3 months.
with books_borrowed as (select t.*,b.ISBN from books b join transaction t on b.book_id = t.book_id where date(now()) - borrowed_on < 250)
  select distinct books.ISBN from books where get_number_of_copies(books.ISBN) > 2
  except
  select distinct books_borrowed.ISBN from books_borrowed;

-- 7)Show the library user who borrowed the maximum books in a given period. (Eg: Jan 2018)
select user_id, count(user_id) from get_transactions_in_given_month(7,2017)
  group by user_id order by count desc;

-- 8)Show the library user(s) who are in possession of a library book for more then 15 days.
select distinct user_id,bwd_by as user_name from currently_bwd_books
where dur_in_days>15;

-- 9)Show the library user(s) who are in possession of more than two library books and holding atleast two of them for more then 15 days.
with bwd_books_count as
  (select
   bwd_by,count(user_id) as no_of_books from currently_bwd_books
   where dur_in_days>15
   group by bwd_by
   order by no_of_books desc)
select bwd_by from bwd_books_count where no_of_books >= 2;

-- 11)Show the titles that are in high demand and copies not available.
select * from detailed_transaction where bwd_duration_in_days <7;

-- 12) Show the average period of holding the borrowed books that were returned in a certain period. (Eg: Jan 2018).
select avg(returned_on - borrowed_on) avg_of_time_of_holding_book from
  get_transactions_in_given_month(6,2017);
