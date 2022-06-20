import * as d3 from 'd3';

(() => {
  const boxHeight = 300;
  const svg = d3.create('svg').attr('viewBox', [0, 0, width, boxHeight]);

  let nodes = [];
  nodes.push([width / 2, boxHeight / 1.5]);
  nodes.push([width / 4, boxHeight / 3]);
  nodes.push([width / 1.5, boxHeight / 3]);

  for (let i = 0; i < nodes.length; i++) {
    svg
      .append('circle')
      .attr('cx', nodes[i][0])
      .attr('cy', nodes[i][1])
      .attr('r', 20)
      .style('fill', 'green');
  }

  let links = [];
  // Link from the first node to the second
  links.push(
    d3.linkVertical()({
      source: nodes[0],
      target: nodes[1]
    })
  );

  // Link from the first node to the third
  links.push(
    d3.linkVertical()({
      source: nodes[0],
      target: nodes[2]
    })
  );

  // Append the links to the svg element
  for (let i = 0; i < links.length; i++) {
    svg
      .append('path')
      .attr('d', links[i])
      .attr('stroke', 'black')
      .attr('fill', 'none');
  }

  return svg.node();
})();
