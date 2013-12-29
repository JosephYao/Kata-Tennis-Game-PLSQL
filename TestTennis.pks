create or replace package ut_tennis
is
	procedure ut_setup;
	procedure ut_teardown;

	procedure ut_love_all;
	procedure ut_fifteen_love;
	procedure ut_thirty_love;
	procedure ut_forty_love;
	procedure ut_love_fifteen;
	procedure ut_fifteen_all;
	procedure ut_deuce;
	procedure ut_deuce_again;
	procedure ut_first_player_adv;
	procedure ut_first_player_adv_again;
	procedure ut_second_player_adv;
	procedure ut_first_player_win_no_deuce;
	procedure ut_first_player_win_no_deuce_2;
	procedure ut_second_player_win_no_deuce;
	procedure ut_first_player_win_deuce;
	procedure ut_first_player_win_deuce_2;
	procedure ut_second_player_win_deuce;

	procedure first_player_get_points (times integer);
	procedure second_player_get_points (times integer);
	procedure deuce;
	procedure deuceAgain;
end ut_tennis;
/

create or replace package body ut_tennis
is
	game TennisGame;

	procedure ut_setup is
	begin
		game := TennisGame('Joseph', 'Jackson');
	end;

	procedure ut_teardown is
	begin
		null;
	end;

	procedure ut_love_all is
	begin
		utAssert.eq('Score equals', game.score(), 'Love All');
	end;

	procedure ut_fifteen_love is
	begin
		first_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Fifteen Love');
	end;

	procedure ut_thirty_love is
	begin
		first_player_get_points(2);
		utAssert.eq('Score equals', game.score(), 'Thirty Love');
	end;

	procedure ut_forty_love is
	begin
		first_player_get_points(3);
		utAssert.eq('Score equals', game.score(), 'Forty Love');
	end;

	procedure ut_love_fifteen is
	begin
		second_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Love Fifteen');
	end;

	procedure ut_fifteen_all is
	begin
		first_player_get_points(1);
		second_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Fifteen All');
	end;

	procedure ut_deuce is
	begin
		deuce;
		utAssert.eq('Score equals', game.score(), 'Deuce');
	end;

	procedure ut_deuce_again is
	begin
		deuceAgain;
		utAssert.eq('Score equals', game.score(), 'Deuce');
	end;

	procedure ut_first_player_adv is
	begin
		deuce;
		first_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Joseph Advantage');
	end;

	procedure ut_first_player_adv_again is
	begin
		deuceAgain;
		first_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Joseph Advantage');
	end;

	procedure ut_second_player_adv is
	begin
		deuce;
		second_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Jackson Advantage');
	end;

	procedure ut_first_player_win_no_deuce is
	begin
		first_player_get_points(4);
		utAssert.eq('Score equals', game.score(), 'Joseph Win');
	end;

	procedure ut_first_player_win_no_deuce_2 is
	begin
		first_player_get_points(3);
		second_player_get_points(1);
		first_player_get_points(1);
		utAssert.eq('Score equals', game.score(), 'Joseph Win');
	end;

	procedure ut_second_player_win_no_deuce is
	begin
		second_player_get_points(4);
		utAssert.eq('Score equals', game.score(), 'Jackson Win');
	end;

	procedure ut_first_player_win_deuce is
	begin
		deuce;
		first_player_get_points(2);
		utAssert.eq('Score equals', game.score(), 'Joseph Win');
	end;

	procedure ut_first_player_win_deuce_2 is
	begin
		deuceAgain;
		first_player_get_points(2);
		utAssert.eq('Score equals', game.score(), 'Joseph Win');
	end;

	procedure ut_second_player_win_deuce is
	begin
		deuce;
		second_player_get_points(2);
		utAssert.eq('Score equals', game.score(), 'Jackson Win');
	end;

	procedure first_player_get_points(times integer) is
	begin
		for counter in 1..times loop
			game.first_player_get_point;
		end loop;
	end;

	procedure second_player_get_points(times integer) is
	begin
		for counter in 1..times loop
			game.second_player_get_point;
		end loop;
	end;

	procedure deuce is
	begin
		first_player_get_points(3);
		second_player_get_points(3);
	end;

	procedure deuceAgain is
	begin
		deuce;
		first_player_get_points(1);
		second_player_get_points(1);
	end;

end ut_tennis;
/

set serveroutput on
/

exec utplsql.run ('ut_tennis', per_method_setup_in => TRUE)
/

