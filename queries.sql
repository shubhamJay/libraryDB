-- 1. Show the total titles available in the library.
select book_name,count from count_of_book;

-- 2)  Show the titles with highest number of copies.
select book_name,count from count_of_book where count = (select max(count) from count_of_book);

-- 3) Show the titles with five or less copies.
select * from count_of_book where count<5 order by count desc;

-- 4)Show the titles borrowed the most in a given month. (Eg: Sep 2017)
select book_name, count(book_name) as count from get_transactions_in_given_month(6,2017)
  group by book_name order by count desc;

-- 5)Show the titles not borrowed for more than four months as of current date.
with books_borrowed_within_four_months as( select isbn,book_name from detailed_transaction where (current_date-borrowed_on<120))
select * from old_books except select * from books_borrowed_within_four_months;

-- 6) Show the titles with more than 10 copies and not borrowed for the last 3 months.
with books_borrowed_within_3_months as( select isbn,book_name, count(isbn) as number_of_book  from detailed_transaction where (current_date-borrowed_on<90) group by isbn,book_name)
select isbn, book_name ,count from count_of_book where count > 10
except select * from books_borrowed_within_3_months;

-- 7)Show the library user who borrowed the maximum books in a given period. (Eg: Jan 2018)
select u.user_id,u.name,count(user_id) from get_transactions_in_given_month(8,2017) join users u using (user_id)
  group by u.user_id,u.name order by count desc;

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

--10)Show the titles that are in high demand and copies not available.
with unavailable_books as (
  select * from books join count_of_book using (isbn) where availability is false order by count desc)
select isbn,book_name,(count(book_name)/count::float) as demand_ratio from unavailable_books group by count,isbn, book_name order by demand_ratio desc;

-- 11)Show the titles that are in high demand and copies not available.
select * from detailed_transaction where bwd_duration_in_days <7;

-- 12) Show the average period of holding the borrowed books that were returned in a certain period. (Eg: Jan 2018).
select avg(bwd_duration_in_days) avg_period_of_holding from
  get_transactions_in_given_month(6,2017);
