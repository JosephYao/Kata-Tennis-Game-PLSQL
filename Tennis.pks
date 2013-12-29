create or replace package tennis as
	type score_text_type is table of varchar2(30); 
	function get_score_text (player_point integer) return varchar2;
end tennis;
/

create or replace package body tennis as
	function get_score_text (player_point integer) return varchar2 is
		result constant score_text_type := score_text_type('Love', 'Fifteen', 'Thirty', 'Forty');
	begin
		return result(player_point + 1);
	end;
end tennis;
/

create or replace type TennisGame as object (
	FORTY integer,
	first_player_point integer,
	second_player_point integer,
	first_player_name varchar2(100),
	second_player_name varchar2(100),
	member function score return varchar2,
	member procedure first_player_get_point,
	member procedure second_player_get_point,
	constructor function TennisGame (first_player_name varchar2, second_player_name varchar2) return self as result,
	member function isDraw return boolean,
	member function isDeuce return boolean,
	member function isAdvantage (advantager_player_point integer, another_player_point integer) return boolean,
	member function isPlayerWinWithoutDeuce (winner_point integer, another_player_point integer) return boolean,
	member function isPlayerWinWithDuece (winner_point integer, another_player_point integer) return boolean,
	member function drawScore return varchar2, 
	member function normalScore return varchar2,
	member function advantageScore (player_name varchar2) return varchar2,
	member function winScore (player_name varchar2) return varchar2
);
/

create or replace type body TennisGame 
as

	constructor function TennisGame (first_player_name varchar2, second_player_name varchar2) return self as result is
	begin
		self.FORTY := 3;
		self.first_player_point := 0;
		self.second_player_point := 0;
		self.first_player_name := first_player_name;
		self.second_player_name := second_player_name;
		return;
	end;

	member function score return varchar2 is
	begin
		if (isPlayerWinWithDuece(second_player_point, first_player_point)) then
			return winScore(second_player_name);
		end if;

		if (isPlayerWinWithDuece(first_player_point, second_player_point)) then
			return winScore(first_player_name);
		end if;

		if (isPlayerWinWithoutDeuce(second_player_point, first_player_point)) then
			return winScore(second_player_name);
		end if;

		if (isPlayerWinWithoutDeuce(first_player_point, second_player_point)) then
			return winScore(first_player_name);
		end if;

		if (isAdvantage(second_player_point, first_player_point)) then
			return advantageScore(second_player_name);
		end if;

		if (isAdvantage(first_player_point, second_player_point)) then
			return advantageScore(first_player_name);
		end if;

		if (isDeuce) then
			return 'Deuce';
		end if;

		if (isDraw) then
			return drawScore;
		end if;

		return normalScore;
	end;

	member function winScore (player_name varchar2) return varchar2 is
	begin
		return player_name || ' Win';
	end;

	member function advantageScore (player_name varchar2) return varchar2 is
	begin
		return player_name || ' Advantage';
	end;

	member function normalScore return varchar2 is
	begin
		return tennis.get_score_text(first_player_point) || ' ' || tennis.get_score_text(second_player_point);
	end;

	member function drawScore return varchar2 is
	begin
		return tennis.get_score_text(first_player_point) || ' All';
	end;

	member function isPlayerWinWithDuece (winner_point integer, another_player_point integer) return boolean is
	begin
		return winner_point - another_player_point = 2 and another_player_point >= FORTY;
	end;

	member function isPlayerWinWithoutDeuce (winner_point integer, another_player_point integer) return boolean is
	begin
		return winner_point = FORTY + 1 and another_player_point < FORTY;
	end;

	member function isAdvantage (advantager_player_point integer, another_player_point integer) return boolean is
	begin
		return advantager_player_point - another_player_point = 1 and another_player_point >= FORTY;
	end;

	member function isDeuce return boolean is
	begin
		return isDraw and first_player_point >= FORTY;
	end;

	member function isDraw return boolean is
	begin
		return first_player_point = second_player_point;
	end;

	member procedure first_player_get_point is
	begin
		first_player_point := first_player_point + 1;
	end;

	member procedure second_player_get_point is
	begin
		second_player_point := second_player_point + 1;
	end;
end;
/
