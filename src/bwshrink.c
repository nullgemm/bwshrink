#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
	if (argc < 5)
	{
		printf("usage: bwshrink <in/rgb> <out/bin> <width> <height>\n");

		return 1;
	}

	// read
	FILE* in = NULL;

	in = fopen(argv[1], "r");

	if (in == NULL)
	{
		printf("invalid in path\n");

		return 1;
	}

	// write
	FILE* out = NULL;

	out = fopen(argv[2], "w");

	if (out == NULL)
	{
		printf("invalid out path\n");

		return 1;
	}

	// area
	uint32_t width = atoi(argv[3]);
	uint32_t height = atoi(argv[4]);

	if ((width < 1) || (height < 1))
	{
		printf("invalid area\n");

		return 1;
	}

	// buffer
	uint8_t* agg = malloc(width);

	if (agg == NULL)
	{
		printf("failed malloc\n");

		return 1;
	}

	memset(agg, 0, width);

	// process
	uint32_t i = 0;
	uint32_t k = 0;
	uint32_t tmp = 0;

	while (!feof(in))
	{
		fread(&tmp, 3, 1, in);
		agg[i] >>= 1; // has no effect on the first round
		agg[i] |= (tmp > 0) ? 0x80 : 0x00;

		++i;

		if (i == width)
		{
			i = 0;
			++k;

			if (k == 8)
			{
				k = 0;
				fwrite(agg, 1, width, out);
				memset(agg, 0, width);
			}
		}
	}

	// cleanup
	free(agg);
	fclose(in);
	fclose(out);

	return 0;
}
