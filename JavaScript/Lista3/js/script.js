document.addEventListener('DOMContentLoaded', function() {
    let btnPesquisar = document.getElementById('btnPesquisar');
    let numeroPkm = document.getElementById('numeroPkm');

    btnPesquisar.onclick = function() {    
      fetch(`http://pokeapi.co/api/v2/pokemon/${ numeroPkm.value }/`)
        .then(response => response.json())
        .then(json => {
          console.log(json);
          console.log(json.sprites.front_default);
          let div = document.getElementById('detalhesPokemon');
          let name = document.createElement('h1');
          name.innerHTML = `Nome: ${ json.name }`;
          let numero = document.createElement('h2');
          numero.innerHTML = `Número: ${ json.id }`;
          let img = document.createElement('img');
          img.src = json.sprites.front_default;

          let types = document.createElement('ul');
            json.types.forEach(a => {
                let li = document.createElement('li');
                li.innerHTML = a.type.name;
                types.append(li);
            });
            let stats = document.createElement('ul');
            json.stats.forEach(a => {
                let li = document.createElement('li');
                let status = document.createElement('progress');
                li.innerHTML = a.stat.name;
                status.max = 100;
                status.value = a.base_stat;
                stats.append(li);
                stats.append(status);
            });   
          div.append(name);
          div.append(numero);
          div.append(img);
          div.append(types);
          div.append(stats);
    	})
    }
})
