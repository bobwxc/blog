---
title: base64 encode in C
date: 2021-06-25
---

``` C
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char b64lst[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// b64 - base64 main process
// @unisigned char *t - input data
// @long l - byte size of input data
// return char *rr, need to free after use
char *b64(unsigned char *t, long l)
{
	unsigned char tt[l + 3];
	memset(tt, 0, l + 3);
	memcpy(tt, t, l);
	tt[l] = '\0';

	int ll = l % 3;
	l += ll;
	long rl = l / 3 * 4;

	char *r = (char *)malloc(sizeof(char) * (rl + 1));
	memset(r, 0, rl + 1);
	r[0] = '\0';
	r[rl] = '\0';

	unsigned char a, b, c, d;
	for (int i = 0, j = 0; i < (l - 2); i += 3, j += 4)
	{
		a = t[i] >> 2;

		b = t[i] << 6;
		b = b >> 2;
		b += t[i + 1] >> 4;

		c = t[i + 1] << 4;
		c = c >> 2;
		c += t[i + 2] >> 6;

		d = t[i + 2] << 2;
		d = d >> 2;

		r[j] = b64lst[(int)a];
		r[j + 1] = b64lst[(int)b];
		r[j + 2] = b64lst[(int)c];
		r[j + 3] = b64lst[(int)d];
	}

	switch (ll)
	{
	case 1:
		r[rl - 1] = '=';
		break;
	case 2:
		r[rl - 1] = '=';
		r[rl - 2] = '=';
		break;
	}

	return r; //remeber to free 'r'
}

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		printf("Need a file path!");
	}

	FILE *fp = fopen(argv[1], "rb");
	unsigned char buff[1026];
	fseek(fp, 0, SEEK_END);
	long l = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	long rl = (int)(l / 3 * 4 + 1);
	char rr[rl];
	memset(rr, 0, rl);
	rr[0] = '\0';

	for (int i = 0, ll = l / 1026 + 1; i < ll; i++)
	{
		char *r;
		fread(buff, sizeof(char), 1026, fp);
		if (i == (ll - 1))
		{
			r = b64(buff, (l % 1026));
		}
		else
		{
			r = b64(buff, 1026);
		}
		strcat(rr, r);
		free(r);
	}

	for (int i = 1, ll = strlen(rr); i <= ll; i++)
	{
		printf("%c", rr[i - 1]);
		if (i % 76 == 0)
			printf("\n");
	}
	printf("\n");
	return 0;
}
```
