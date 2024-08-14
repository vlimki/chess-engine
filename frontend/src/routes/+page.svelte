<script lang="ts">
	const starting_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".split(" ")[0];

	function chunks(arr: any[], n: number) {
  	return arr.reduce((acc, curr, idx) => {
    	if (idx % n === 0) acc.push([]);
	    acc[acc.length - 1].push(curr);
  	  return acc;
  	}, []);
	}

	interface Square {
		piece: string;
		dark?: boolean;
	};

	let squares: Square[] = [];

	for(let i = 0; i < 64; i++) {
		squares[i] = { piece: "", dark: (Math.floor(i/8) + (i % 8)) % 2 == 1 };
	}

	const rows = starting_fen.split("/");
	console.log(rows);

	for(let i = 0; i < rows.length; i++) {
		for(let j = 0; j < rows[i].split("").length; j++) {
			console.log(i, j, rows[i][j]);

			if(!isNaN(parseInt(rows[i][j]))) {
				continue;
			}

			squares[i * 8 + j].piece = rows[i][j];
		}
	}
</script>

<div class="flex flex-row items-center justify-evenly">
	<div class="flex flex-col items-center justify-center ">
		<p> Game</p>
	</div>
	<div class="flex flex-col">
		<div class="flex flex-col border border-black">
			{#each chunks(squares, 8).reverse() as row}
				<div class="flex flex-row">
					{#each row as sq}
						<div class={`h-20 w-20 ${sq.dark ? "bg-black" : "bg-white"} flex flex-col items-center justify-center`}>
							<p class="b text-white">{sq.piece}</p>
						</div>
					{/each}
				</div>
			{/each}
		</div>
	</div>
</div>
<style>
	.b {
		text-shadow: #000 1px 1px 1px;
	}
</style>
