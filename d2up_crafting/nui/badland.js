$(function() {
	// init();
  
	var actionContainer = $(".actionmenu");
  
	window.addEventListener("message", function(event) {
	  var item = event.data;
  
	  if (item.showmenu) {
		requestCrafting(item.data)
		$('body').css('background-color', 'rgba(0, 0, 0, 0.15)')
		actionContainer.fadeIn();
	  }
  
	  if (item.hidemenu) {
		$('body').css('background-color', 'transparent')
		$('.contentContainer').html(``)
		actionContainer.fadeOut();
	  }
	});
  
	document.onkeyup = function(data) {
	  if (data.which == 27) {
		$('body').css('background-color', 'transparent')
		actionContainer.fadeOut();
		$('.contentContainer').html(``)
		$.post("http://d2up_crafting/fechar", JSON.stringify({}));
	  }
	};
});

function requestCrafting(data) {
	for (x = 0;x <= data.qtd - 1;x++) {
		
		$('.contentContainer').append(`
			<div class="itemContainer">
				<div class="itemImage">
					<img src="http://135.148.145.240/imagens/${data.craftings[x].resultindex}.png" alt="">
				</div>
				<div class="itemTitle">
					<span> ${data.craftings[x].name} </span>
				</div>
				<div class="recipeContainer">
					<div class="recipeTitle">
						<span> INGREDIENTES </span>
					</div>
					<div class="recipeImage imagem-${data.craftings[x].resultindex}"></div>
					
				</div>
				<div class="makeItContainer">
					<div class="makeItTitle">
						<span> FABRICAÇÃO </span>
					</div>
					<div id="productButton" class="menuoption" data-craft="${x}" data-tipo="${data.tipo}">
						<span>PRODUZIR</span>
					</div>
					<div class="productionDetails escrever-${data.craftings[x].resultindex}"></div>
				</div>
			</div>
		`);

		for (let [k, v] of Object.entries(data.craftings[x].required)) {
			$('.imagem-'+data.craftings[x].resultindex).append(`
				<img src="http://135.148.145.240/imagens/${k}.png" alt="">
			`)
			$('.escrever-'+data.craftings[x].resultindex).append(`
				<p>${v}x ${k}</p>
			`)
		}

	}
}
  
$(document).on("click", ".menuoption", function () {
	var data = $(this).attr("data-craft")
	var tipo = $(this).attr("data-tipo")
	$.post("http://d2up_crafting/produzir", JSON.stringify({
		index: data,
		tipo: tipo,
	}));
	$('.contentContainer').html(``)
	$.post("http://d2up_crafting/fechar", JSON.stringify({}));
});
