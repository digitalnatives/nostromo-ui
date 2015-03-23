class Member < User
  tag 'member'

  component :picture, :img

  def self.render(target, users)
    target.empty
    users.each do |user|
      member = Member.new
      member.initialize! user
      member.render
      member >> target
    end
  end

  def update!(data)
    @data = data
    render
  end

  # Renders the component
  def render
    self[:id] = @data[:id]
    self[:title] = @data[:name]
    @picture[:src] = @data[:picture]
  end
end
