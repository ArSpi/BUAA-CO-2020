#include<stdio.h>

int factorial[200] = {};

int main()
{
	int n = 0;
	scanf("%d", &n);
	int i = 0;
	int j = 0;
	int k = 0;
	int digit = 1;
	int carry[200] = {};
	factorial[0] = 1;
	for (i = 1; i <= n; i ++)
	{
		for (k = 0; k < digit; k ++)
		{
			carry[k] = 0;
		}
		for (j = 0; j < digit; j ++)//当最高位存在进位时，digit会加1，从而使循环多进行1次，carry中的数据存入factorial 
		{
			factorial[j] = factorial[j] * i + carry[j];
			if (factorial[j] >= 1000000)
			{
				carry[j+1] = factorial[j] / 1000000;
				factorial[j]  %= 1000000;
			}
			if (carry[digit] > 0)
			{
				digit += 1;
			}
		}
	}
	
	printf("%d", factorial[digit-1]);
	for (i = digit-2; i >= 0; i --)
	{
		printf("%06d", factorial[i]);
	}
	
	return 0;
}
