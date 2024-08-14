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
	}

	let squares: Square[] = [];

	for (let i = 0; i < 64; i++) {
		squares[i] = { piece: "", dark: (Math.floor(i / 8) + (i % 8)) % 2 == 1 };
	}

	const rows = starting_fen.split("/");

	for (let i = 0; i < rows.length; i++) {
		let k = 0;
		for (let j = 0; j < rows[i].length; j++) {
			const char = rows[i][j];

			if (!isNaN(parseInt(char))) {
				k += parseInt(char);
			} else {
				squares[i * 8 + k].piece = char;
				k++;
			}
		}
	}

	let draggingPiece: string | null = null;
	let draggingFrom: number | null = null;

	function handleDragStart(piece: string, index: number) {
		draggingPiece = piece;
		draggingFrom = index;
	}

	function handleDragOver(event: DragEvent) {
		event.preventDefault();
	}

	function handleDrop(index: number) {
		if (draggingPiece !== null && draggingFrom !== null) {
			squares[index].piece = draggingPiece;
			squares[draggingFrom].piece = "";
			draggingPiece = null;
			draggingFrom = null;
		}
	}
</script>

<div class="flex flex-row items-center justify-evenly h-screen">
	<div class="flex flex-col items-center justify-center">
		<p>Game</p>
	</div>
	<div class="flex flex-col">
		<div class="flex flex-col border border-black">
			{#each chunks(squares, 8).reverse() as row, rowIndex}
				<div class="flex flex-row">
					{#each row as sq, colIndex}
						<div
							class={`h-20 w-20 ${sq.dark ? "bg-black" : "bg-white"} flex flex-col items-center justify-center`}
							on:dragover={handleDragOver}
							on:drop={() => handleDrop((7 - rowIndex) * 8 + colIndex)}
						>
							{#if sq.piece}
								<p
									class="b text-white"
									draggable="true"
									on:dragstart={() => handleDragStart(sq.piece, (7 - rowIndex) * 8 + colIndex)}
								>
									{sq.piece}
								</p>
							{/if}
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
		cursor: grab;
	}
</style>

