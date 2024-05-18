class BattleshipController < ApplicationController
    before_action :set_game, only: [:attack]
  
    @@ships = []
    @@hits = Hash.new(0)
  
    def initialize_game
      positions = params[:positions]
  
      if positions.length != 3 || positions.any? { |pos| !valid_position?(pos) }
        return render json: { message: "invalid positions" }, status: :unprocessable_entity
      end
  
      @@ships = positions.map do |pos|
        { 
          top: pos,
          cells: generate_ship_cells(pos),
          hits: 0 
        }
      end
  
      render json: { message: "ok" }
    end
  
    def attack
      x, y = params[:x].to_i, params[:y].to_i
      return render json: { message: "miss" } unless valid_coordinate?(x, y)
  
      ship = find_ship(x, y)
      if ship
        ship[:hits] += 1
        @@hits[[x, y]] += 1
        if ship[:hits] == 3
          render json: { message: "sunk" }
        else
          render json: { message: "hit" }
        end
      else
        render json: { message: "miss" }
      end
    end
  
    private
  
    def set_game
      @@ships ||= []
      @@hits ||= Hash.new(0)
    end
  
    def valid_position?(pos)
      pos.is_a?(Array) && pos.length == 2 && pos.all? { |coord| coord.between?(0, 9) }
    end
  
    def generate_ship_cells(top)
      (0..2).map { |i| [top[0], top[1] - i] }
    end
  
    def valid_coordinate?(x, y)
      x.between?(0, 9) && y.between?(0, 9)
    end
  
    def find_ship(x, y)
      @@ships.find { |ship| ship[:cells].include?([x, y]) }
    end
  end
  