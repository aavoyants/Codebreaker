require 'spec_helper'

module Codebreaker
  describe Game do
    let(:output) { double('output').as_null_object }
    let(:game)   { Game.new(output, 3) }

    describe "#start" do
      it "sends a welcome message" do
        output.should_receive(:puts).with("Welcome to Codebreaker! You have 3 guesses and 2 hints")
        game.stub(:gets).and_return('')
        game.stub(:gameover).as_null_object
        game.start('1234')
      end

      it "prompts for the first guess" do
        output.should_receive(:puts).with('Enter guess:')
        game.stub(:gets).and_return('')
        game.stub(:gameover).as_null_object
        game.start('1234')
      end
    end

    describe "#continue" do
      context "when 'h'" do
        it "gives a hint" do
          output.should_receive(:puts).with('The first number is: 1')
          game.instance_variable_set(:@current_guess, 2)
          game.stub(:gets).and_return('h')
          game.stub(:play_again).as_null_object
          game.start('1234')
         end

        it "sends a message when all hints are used" do
          game.instance_variable_set(:@current_hint, 2)
          output.should_receive(:puts).with('You have already used all your hints')
          game.hint
        end
      end

      it "ends the game when all guesses are used" do
        game.instance_variable_set(:@current_guess, 3)
        game.stub(:play_again).as_null_object
        output.should_receive(:puts).with('You lose...')
        game.continue
      end

      context "when 'q'" do
        xit "quits the game" do

        end
      end
    end

    describe "#guess" do
      it "sends the mark to output" do
        game.stub(:continue).as_null_object
        game.start('1234')
        output.should_receive(:puts).with('+++')
        game.guess('1233')
     end

      it "informs about guesses left" do
        game.stub(:continue).as_null_object
        game.start('1234')
        output.should_receive(:puts).with("You have 2 guess(es) left")
        game.guess('1111')
      end

      context "when 4 exact matches" do
        it "sends a 'you win' message" do
          game.stub(:continue).as_null_object
          game.stub(:gameover).as_null_object
          game.stub(:gets).and_return('')
          game.start('1234')
          output.should_receive(:puts).with('You win at 1 guess! Enter your name:')
          game.guess('1234')
        end

        it "saves the score" do

        end
      end
    end
  end
end