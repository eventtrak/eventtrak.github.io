# -*- coding: utf-8 -*-
namespace :admin do
  desc "Reset database and populate it with test data"
  task :reset_and_fill_db => :environment do
    puts "Emptying database..."	# So old relations/ids/etc don't mess things up
    Rake::Task["db:reset"].invoke
    puts "Filling database..."
    Rake::Task["admin:fill_db"].invoke
  end

  desc "Populate database with test data"
  task :fill_db => :environment do
    
    v1 = Venue.create(capacity: 300, name: "Bug Jar",
                      address: '219 Monroe', city: "Rochester", state: "New York",
                      url: 'http://bugjar.com',
                      min_price: 3500*100, max_price: 5000*100, min_age: 18, equipment: 'Sound & Light')

    v2 = Venue.create(capacity: 700, name: "Wheeler Hall",
                      address: '208 Some Street', city: "Berkeley", state: "California",
                      url: 'http://calperfs.berkeley.edu/visit/venues/wa.php',
                      min_price: 100*100, max_price: 200*100, min_age: 19, equipment: 'stuff')

    a1 = Artist.create(artist_name: 'The Beatles', route_name: 'beatles', email: 'beatles@gmail.com', password: 'foobar',
                       description: %q{The Beatles were an English rock band that formed in Liverpool, in 1960. With John Lennon, Paul McCartney, George Harrison, and Ringo Starr, they became widely regarded as the greatest and most influential act of the rock era. Rooted in skiffle and 1950s rock and roll, the Beatles later experimented with several genres, ranging from pop ballads to psychedelic rock, often incorporating classical elements in innovative ways. In the early 1960s, their enormous popularity first emerged as "Beatlemania", but as their songwriting grew in sophistication they came to be perceived as an embodiment of the ideals shared by the era's sociocultural revolutions.}
                       )
    
    a2 = Artist.create(artist_name: 'Queen', route_name: 'queen', email: 'queen@gmail.com', password: 'foobar',
                       description: %q{Queen are a British rock band formed in London in 1970, originally consisting of
 Freddie Mercury (lead vocals, piano), Brian May (guitar, vocals), John Deacon (bass guitar), and Roger Taylor (drums, vocals).
Queen's earliest works were influenced by progressive rock, hard rock and heavy metal, but the band gradually ventured into more
 conventional and radio-friendly works, incorporating further diverse styles into their music.})
    
    a3 = Artist.create(artist_name: 'Joe Hisaishi', route_name: 'joe', email: 'joe@gmail.com', password: 'foobar',
                       description: %q{Mamoru Fujisawa (藤澤 守 Fujisawa Mamoru), known professionally as Joe Hisaishi (久石 譲 Hisaishi Jō, born December 6, 1950), is a composer and musical director known for over 100 film scores and solo albums dating back to 1981.
While possessing a stylistically distinct sound, Hisaishi's music has been known to explore and incorporate different genres, including minimalist, experimental electronic, European classical, and Japanese classical. Lesser known are the other musical roles he plays; he is also a typesetter, author, arranger, and conductor.})

    e1 = Event.create(artist_id: a1.id, goal: 4000*100)
    vd = VenueDate.create(date: DateTime.new(2014, 2, 14, 16, 0, 0), venue_id: v1.id, event_id: e1.id)
    t1 =  TicketModel.create(name: "General", description: "A standard ticket, good for most purposes.",
                             value: 10*100, max_amount: 275, event_id: e1.id)
    t2 =  TicketModel.create(name: "VIP",
                             description: 'Get to meet-and-greet the Beatles before the show and get
backstage access during the soundcheck.', 
                             value: 19*100, max_amount: 10, event_id: e1.id)
    Performer.create(artist_id: a2.id, event_id: e1.id)
    Performer.create(artist_id: a3.id, event_id: e1.id)

    e2 = Event.create(artist_id: a3.id, goal: 1500*100)
    vd = VenueDate.create(date: DateTime.new(2014, 5, 23, 18, 0, 0), venue_id: v2.id, event_id: e2.id)
    t3 =  TicketModel.create(name: "General", description: "A standard ticket, good for most purposes.",
                             value: 7.5*100, max_amount: 650, event_id: e2.id)
    # t2 =  TicketModel.create(description: "VIP", value: 25*100, max_amount: 10, event_id: e2.id)
    
    
  end

  desc "Buys 40 basic tickets and one VIP ticket for first Event in database"
  task :buy_tickets, [:event_id, :basic_num, :vip_num] => :environment do |t, args|
    args.with_defaults(event_id: 1, basic_num: 40, vip_num: 0)
    id = args[:event_id].to_i
    basic_num = args[:basic_num].to_i
    vip_num = args[:vip_num].to_i
    
    puts "Buying tickets for event #{id}..."
    
    event = Event.find_by_id(id)
    tm = event.ticket_models
    
    for i in 1..basic_num
      puts "Buying basic ticket #{i}..."
      tm[0].make_ticket false
    end

    for i in 1..vip_num
    puts "Buying VIP ticket #{i}..."
    tm[1].make_ticket false
    end

  end

  desc "Buys enough basic tickets to fund first Event."
  task :fund_event, [:event_id] => :environment do |t, args|
    args.with_defaults(:event_id => 1)
    id = args[:event_id].to_i

    puts "Funding event #{id}..."

    event = Event.find_by_id(id)

    pf, raised = event.percent_funded_raised
    tm = event.ticket_models
    tickets_left = (event.goal - raised + 0.0) / tm[0].post_stripe_value
    tickets_left = tickets_left.ceil
    
    if tickets_left > 0
      for i in 1..tickets_left
        puts "Buying basic ticket #{i}..."
        tm[0].make_ticket false
      end
    end
  end

  
end


