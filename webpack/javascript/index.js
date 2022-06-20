import * as d3 from "d3"

window.addEventListener('load', () => {
  const main = document.querySelector('main');
  // create svg the same size as main
  const svg = d3.create('svg')
    .attr('id', 'links')
    .attr('viewBox', [0, 0, main.offsetWidth, main.offsetHeight]);
  const links = [];
  // Generate links array
  document.querySelectorAll('.row').forEach(row => {
    const leftNode = row.querySelector('.node');
    const level = parseInt(leftNode.dataset.level);
    const rightNodes = row.querySelectorAll(`.node[data-level='${level + 1}']`);
    rightNodes?.forEach(rightNode => {
      const leftAnchor = [leftNode.offsetLeft + leftNode.offsetWidth, leftNode.offsetTop + leftNode.offsetHeight / 2]
      const rightAnchor = [rightNode.offsetLeft, rightNode.offsetTop + rightNode.offsetHeight / 2]
      links.push(
        d3.linkHorizontal()({
          source: leftAnchor,
          target: rightAnchor
        })
      )
    })
  })
  links.forEach(link => {
    svg.append('path')
      .attr('d', link)
      .attr('stroke', 'black')
      .attr('fill', 'none');
  })
  main.appendChild(svg.node());
})