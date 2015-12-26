vs = 0
graph = {}

File.readlines(ARGV[0]).each_with_index do |line, i|
  if i > 0
    from, to, w = line.split(" ").map { |n| n.to_i }
    graph[from] << {v: to,   w: w}
    graph[to]   << {v: from, w: w}
  else
    vs = line.to_i
    vs.times do |t|
      graph[t + 1] = []
    end
  end
end

#######################################################

puts "#######################################################"
puts
puts "BUILDING GRAPH..."
puts vs
graph.each do |vertex, edges|
  puts "#{vertex} => #{edges.inspect}"
end
puts "DONE!"

#######################################################

def dijkstra(graph, source)
  dist = {}
  prev = {}
  q = graph.keys

  graph.keys.each do |v|
    dist[v] = 99999
    prev[v] = nil
  end

  dist[source] = 0

  loop do
    dist_q = dist.map { |v, w| q.include?(v) ? w : nil }.compact
    u = q.find  { |v| dist[v] == dist_q.min }
    q.delete_if { |v| v == u }

    graph[u].each do |e|
      v = e[:v]
      w = e[:w]

      if q.include? v
        alt = dist[u] + w
        if alt < dist[v]
          dist[v] = alt
          prev[v] = u
        end
      end
    end

    break if q.empty?
  end

  return dist, prev
end

#######################################################

def shortest_path(prevs, source, dest)
  route = [dest]
  loop do
    prev = prevs[dest]
    route.unshift(prev)
    dest = prev

    return route if prev == source
  end
end

#######################################################

puts
puts "#######################################################"
puts
puts "Press Ctrl+C when you have found your way"
puts
puts "#######################################################"
puts

loop do
  print "Enter source: "
  s = STDIN.gets.chomp.to_i

  print "Enter destination: "
  d = STDIN.gets.chomp.to_i

  _, prev = dijkstra(graph, s)
  path       = shortest_path(prev, s, d)

  puts "Shortest path from #{s} to #{d} is: #{path.join(', ')}"
  puts
  puts "#######################################################"
  puts
end

