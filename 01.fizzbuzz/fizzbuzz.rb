# fizzbuzz.rb

(1..20).each do |i|

    # iが3と5両方の倍数の場合には、FizzBuzzと表示する
    # （言い換えると）iを3で割ったときに余りが出ないかつ、iを5で割ったときに余りが出ないなら、FizzBuzzと表示する
    if i % 3 == 0 && i % 5 == 0
        puts "FizzBuzz"

    # iが3の倍数のときは、Fizzと表示する
    # （言い換えると）iを3で割ったときに余りが出ないなら、Fizzと表示する
    elsif i % 3 == 0
        puts "Fizz"

    # iが5の倍数のときは、Buzzと表示する
    # （言い換えると）iを5で割ったときに余りが出ないなら、Buzzと表示する
    elsif i % 5 == 0
        puts "Buzz"   

    elsif
        puts i
    end
end
