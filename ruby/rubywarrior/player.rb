
class Player
  def play_turn w
    @state   ||= :adv
    @behind  ||= :yes
    @last_hp ||= w.respond_to?(:health) && w.health

    @reduced_hp = @last_hp - w.health if w.respond_to?(:health)

    ## begin rest
    if w.respond_to?(:health) &&
       @state == :rest && w.health < 20

      if @reduced_hp > 0
        w.walk!(:backward)
      else
        w.rest!
      end

    elsif w.respond_to?(:health) &&
          (w.health < 10 || @reduced_hp > w.health)

      w.walk!(:backward)
      @state = :rest
    ## end rest

    ## begin pivot
    elsif w.respond_to?(:feel) && w.respond_to?(:pivot!) &&
          w.feel.wall?

      w.pivot!
      @state  = :adv

    elsif w.respond_to?(:feel) && w.respond_to?(:pivot!) &&
          @behind == :yes && w.feel(:backward).empty?

      w.pivot!
      @behind = :no
      @state  = :adv
    ## end pivot

    ## begin attack
    elsif w.respond_to?(:look) &&
         (s = w.look.find{ |s| s.enemy? || s.captive? }) && s.enemy?

      w.shoot!
      @state = :atk

    elsif w.respond_to?(:feel) && w.feel.enemy?
      w.attack!
      @state = :atk
    ## end attack

    ## begin rescue
    elsif w.respond_to?(:feel) && w.feel.captive?
      w.rescue!
      @state = :adv
    ## end rescue

    ## begin walk
    else
      w.walk!
      @behind = :no
      @state  = :adv
    end
    ## end walk

    @last_hp = w.health if w.respond_to?(:health)
  end
end
