#include <iostream>
#include <string>
#include <math.h>
#include <getopt.h>
#include <vector>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag, LRU;
//	unsigned int	data[16];  
	cache_content(){LRU = 0;}  
};

const int K=1024;

void simulate(int cache_size, int block_size, int asso, string& test_file_name){
	FILE * fp=fopen(test_file_name.c_str(),"r");    //read file
	
	if(!fp) {
		cout << "Test file doesn't exist\n";
		return;
	}
	
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size/asso);
	int line= cache_size>>(offset_bit + (int) log2(asso));
	int hit_times = 0, miss_times = 0, instruction_num = 0, LRU_num = 0;
	vector<int> hit_instruction, miss_instruction;

	// cout << "fuck" << endl;
	cache_content **cache = new cache_content*[line];
	for(int i = 0; i < line; i++){
		cache[i] = new cache_content[asso];
	}
	// cout<<"cache line:"<<line<<endl;

	// cout << "binary fuck" << endl;
	for(int j=0;j<line;j++){
		for(int i = 0; i < asso; i++){
			cache[j][i].v=false;
		}
	}
	// cout << "a" << endl;

	while(fscanf(fp,"%x",&x)!=EOF){
		instruction_num++;
		// cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);

		bool hit = false;
		for(int i = 0; i < asso; i++){
			if(cache[index][i].v && cache[index][i].tag == tag){
				cache[index][i].v = true;    //hit
				cache[index][i].LRU = LRU_num;
				LRU_num++;
				hit_times++;
				hit_instruction.push_back(instruction_num);
				hit = true;
				break;
			}
			else{					

				cache[index][i].v = true;    //miss
				cache[index][i].tag = tag;
			}
		}
		bool full = true;
		if(hit == false){
			for(int i = 0; i < asso; i++){
				if(cache[index][i].v == false){		//find invalid
					cache[index][i].v = true;
					cache[index][i].LRU = LRU_num;
					LRU_num++;
					miss_times++;
					miss_instruction.push_back(instruction_num);
					full = false;
					break;
				}
			}
			if(full){ 								//find Least recently used
				int min = 1000000, LRU_idx;
				for(int i = 0; i < asso; i++){
					if(cache[index][i].LRU < min){
						min = cache[index][i].LRU;
						LRU_idx = i;
					}
				}
				cache[index][LRU_idx].v = true;
				cache[index][LRU_idx].LRU = LRU_num;
				LRU_num++;
				miss_times++;
				miss_instruction.push_back(instruction_num);
				full = false;
			}
		}
	}

	cout << "Miss rate : " << 100*((double)miss_times/instruction_num) << "%";
	cout << endl;
	cout << "Hits instructions : ";
	for(int i = 0; i < hit_instruction.size(); i++){
		cout << hit_instruction[i] << " ";
	}
	cout << endl << "Misses instructions : ";
	for(int i = 0; i < miss_instruction.size(); i++){
		cout << miss_instruction[i] << " ";
	}
	cout << endl;

	fclose(fp);

	delete [] cache;
}

int main(int argc, char** argv){
	string test_file_name;
	int cache_size = 4;
	int block_size = 16;
	int associativity = 1;
	int current_option;
	while((current_option = getopt(argc, argv, "f:c:b:a:")) != EOF) {
        switch(current_option) {
            case 'f': {
               test_file_name = string(optarg);
               break;
            }
            case 'c': {
                cache_size = atoi(optarg); 
                break;
            }
            case 'b': {
                block_size = atoi(optarg);
                break;
            }
			case 'a': {
                associativity = atoi(optarg);
                break;
            }
        }
    }
	
	// default simulate 4KB direct map cache with 16B blocks
	simulate(cache_size*K, block_size, associativity, test_file_name);
}


