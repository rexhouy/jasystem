module OrdersHelper

  def status_class(door)
    if door.finished?
      "finished"
    elsif door.delayed?
      "delayed"
    else
      "unfinished"
    end
  end

end
