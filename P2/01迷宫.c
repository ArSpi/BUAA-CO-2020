#include<stdio.h>

int n = 0;
int m = 0;
int maze[8][8] = {};
int visit[8][8] = {}; 
int sx = 0;
int sy = 0;
int ex = 0;
int ey = 0;
int way = 0;

void dfs(int x, int y);

int main()
{
	scanf("%d", &n);
	scanf("%d", &m);
	int i = 0;
	int j = 0;
	for (i = 0; i < n; i ++)
	{
		for (j = 0; j < m; j ++)
		{
			scanf("%d", &maze[i][j]);
		}
	}
	scanf("%d", &sx);
	scanf("%d", &sy);
	scanf("%d", &ex);
	scanf("%d", &ey);
	
	dfs(sx-1, sy-1);
	
	printf("%d", way);
	return 0;
}

void dfs(int x, int y)
{
	if (((x < 0) || (x >= n) || (y < 0) || (y >= m)) || (maze[x][y] == 1) || (visit[x][y] == 1))//不要跳出迷宫，不要碰墙，不要走重复的路 
	{
		return;
	}
	if ((x == ex-1) && (y == ey-1))
	{
		way++;
		return;
	}
	visit[x][y] = 1;
	dfs(x,y+1);//right
	dfs(x,y-1);//left
	dfs(x+1,y);//down
	dfs(x-1,y);//up
	visit[x][y] = 0;
	return;
}
