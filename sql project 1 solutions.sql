#1)who is senior most employee based on job title

SELECT * FROM employee
order by levels desc limit 1

#2)which country have most invoices?

SELECT count(*) as cnt, billing_country from invoice
group by billing_country
order by cnt desc limit 1

#3)what are top 3 value of total invoice 

select * from invoice
order by total desc limit 3

#4)which city  has the best customer ? we would like to throw a promotional music festival in city we made the most money . write a query that return 
#one city that has highest the sum of invoice totals.
#return both the city name & sum of all invoice total
	
select billing_city ,sum(total) as invoicetotal from invoice
group by billing_city
order by invoicetotal desc
limit 1;	

#5)who is the best customer . the best customer who has spent the most money will be declared the best customer . write a query that return the person 
#who has spent the most money


select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total_spending 
from customer join invoice
on customer.customer_id =invoice.customer_id
group by customer.customer_id
order by total_spending desc
limit 1

6) write a query to return the email,first name ,last name &genre  of all rock music listener.
	return your list orderd alphabatically by email starting with A


select distinct email,first_name,last_name
from customer 
join invoice on customer.customer_id =invoice.customer_id
join invoice_line on invoice_line.invoice_id= invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre  on track.genre_id = genre.genre_id
where genre.name = 'Rock'
order by email;

7)let's invite the artist who have written the most rock music in our dataset . write a query 
  that return the artist name and total track count of the top 10 rock bands.

select artist.name,artist.artist_id,count(artist.artist_id) as number_of_songs
from artist
join album on  album.artist_id = artist.artist_id 
join track on track.album_id =album.album_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;



#8)return the all track name that have a song lenght longer than average  song length.return the name and milliseconds  for each track .order by
# the song length with the longest songs listed first

select name,milliseconds from track
where milliseconds >(SELECT avg(milliseconds) as average_song_length FROM public.track)
order by milliseconds desc

	
	
	#9)find how much amount spent by each customer on artist .write a query to return customer name, artist name, total spent.

with best_selling_artist as 
	(select artist.artist_id as artist_id,artist.name as artist_name,sum(invoice_line.unit_price*invoice_line.quantity) as total_sale
from invoice_line 
join track on track.track_id =invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id =album.artist_id
group by 1
order by 3 desc
limit 1)

select customer.customer_id, customer.first_name,customer.last_name,best_selling_artist.artist_name,sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer on customer.customer_id = invoice.customer_id
join invoice_line on invoice_line.invoice_id =invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join album on album.album_id= track.album_id
join best_selling_artist on best_selling_artist.artist_id= album.artist_id
group by 1,4 
order by 5 desc

#10) we want to find out the most popular music genre for each country. we determine the most popular genre as the genre with
	the highest amount of purchase .write a query that return each country along with top genre. for countries where the
	maximum number of purchASE is shared return all genre 

with popular_genre as
( select count(invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
	row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rowno
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	
	order by 2 asc, 1 desc)
select * from popular_genre where rowno = 1

#11) write a query that determines the customer that has spent the most on music for each country . 
	write a query that return the country along with the top customer and how much they spent . for countries where top amount spent 
	is shared, provide all  customer who spent this amount.

	with customer_with_country as (
select customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total)as total_spending,
	row_number() over(partition by billing_country order by sum(invoice.total)desc)as rowno
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4 asc ,5 desc)

select * from customer_with_country where rowno <=1
	
	
	

   
	



	









	
