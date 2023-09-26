#include <iostream>
#include<fstream>
#include<vector>
#include <bitset>
#include <string>

using namespace std;

struct Package {
	vector<uint8_t> frames;

	Package() {
		frames.push_back(0b0000'0000);
	}

	Package(vector<uint8_t> inputFrames) {
		for (size_t i{ 0 }; i < inputFrames.size(); i++) {
			frames.push_back(inputFrames[i]);
		}
	}
	
	void print() {
		for (size_t i{ 0 }; i < frames.size(); i++) {
			//cout << frames[i]<<"A";
			cout << frames[i];
			//cout << frames[i];
		}
	}

	void append(vector<uint8_t> vec) {

	}
};

uint8_t getCheckSum(vector<uint8_t> frames);

int checkPack(Package sent, Package received);

vector<Package> transmitter(string fileName);

void receiver(vector<Package> packs);

int main() {
	
	uint8_t f00, f01, f02, f10, f11, f12, f20, f21, f22;

	f00 = 0b00001100;
	f01 = 0b00011010;
	f02 = 0b00100000;

	f10 = 0b01000111;
	f11 = 0b01011110;
	f12 = 0b01100110;

	f20 = 0b10001000;
	f21 = 0b10010100;
	f22 = 0b10101100;

	cout << endl << "checkSum " << bitset<8>(getCheckSum({ f00, f01, f02 }));
	cout << endl << "checkSum " << bitset<8>(getCheckSum({ f10, f11, f12 }));
	cout << endl << "checkSum " << bitset<8>(getCheckSum({ f20, f21, f22 }));
	/*
	uint8_t checkSum = getCheckSum({ f00, f01, f02 });//cout << bitset<8>(checkSum) << endl;
	
	Package pack1({ f00, f01, f02, checkSum}), pack2({ f00, f01, f02, 0b0000'0000});

	int receiverCode = checkPack(pack1, pack2);
	switch (receiverCode)
	{
	case 0:
		cout << "The package was accepted without errors!" << endl;
		break;
	case -1:
		cout << "Error -1: Different numbers of frames!" << endl;
		break;
	case -3:
		cout << "Error -3: checksums are different!" << endl;
		break;

	default:
		cout << "Error -2: Frames under the number " << receiverCode << " are different!" << endl;
		break;
	}*/
	
	vector<Package> dataIn = transmitter("data_i.txt");
	int packCount = 0;
	
	for (size_t i{ 0 }; i < dataIn.size(); i++) {
		if (i % 3 == 0) {
			cout <<endl<<endl<< "PACK_" << packCount;
			packCount++;
		}
		cout << endl<< "Frame_" << i <<":	";
		dataIn[i].print();
	}

	/*uint8_t currCheckSum;
	for (size_t i{ 0 }; i < dataIn.size(); i++) {
		if (i % 3 == 0 && i != 0) {
			currCheckSum = getCheckSum({ dataIn[i].frames[0], dataIn[i].frames[1], dataIn[i].frames[2] });
			dataIn[i].frames.push_back(currCheckSum);
		}
	}*/
	/*packCount = 0;
	for (size_t i{ 0 }; i < dataIn.size(); i++) {
		if (i % 4 == 0) {
			cout << endl << endl << "PACK_" << packCount;
			packCount++;
		}
		cout << endl << "Frame_" << i << ":	";
		dataIn[i].print();
	}*/
	return 0;
}

uint8_t getCheckSum(vector<uint8_t> frames) {
	uint8_t partialSum = 0;
	uint8_t checkSum;
	for (size_t i{ 0 }; i < frames.size(); i++) {
		if (i == 0)
			partialSum += frames[i];
		else {
			partialSum = partialSum + frames[i] + 1;
		}
	}
	return checkSum = ~partialSum;
}

int checkPack(Package sent, Package received) {
	bool isOk = true;
	if (sent.frames.size() == received.frames.size()) {

		size_t numOfFrames = sent.frames.size();
		
		
		vector<uint8_t> dataPack1;
		vector<uint8_t> dataPack2;

		for (int i{ 0 }; i < numOfFrames - 1; i++) {
			if (sent.frames[i] == received.frames[i]) {
				dataPack1.push_back(sent.frames[i]);
				dataPack2.push_back(received.frames[i]);
			}
			else {
				//cout << "Error -2: Frames under the number " << i << " are different!" << endl;
				isOk = false;
				return i;
			}
		}
		uint8_t checkSum1 = sent.frames[numOfFrames-1];
		uint8_t checkSum2 = getCheckSum(dataPack2);
		if (checkSum1 != checkSum2) {
			//cout << "Error -3: checksums are different!" << endl;
			isOk = false;
			return -3;
		}
	}
	else {
		//cout << "Error -1: Different numbers of frames!" << endl;
		isOk = false;
		return -1;
	}
	if (isOk) {
		return 0;
	}
	//return 0;
}

vector<Package> transmitter(string fileName) {

	ifstream fin;
	vector<Package> packs;
	
	int counter = 0;

	fin.open(fileName);

	if(fin.is_open()) {
		
		vector<uint8_t> frames;
		uint8_t currFrame;
		uint8_t checkSum;
		Package currPack;
		int frameCnt = 0;
		int i = 0;
		uint8_t tmp1, tmp2, tmp3;
		while (!fin.eof()) {
			/*if (i % 24 == 0 && i != 0) {
				uint8_t checkS;
				int s = frames.size();
				checkS = getCheckSum({	frames[s - 24], frames[s - 23], frames[s - 22], frames[s - 21], frames[s - 20], frames[s - 19], frames[s - 18], frames[s - 17],
										frames[s - 16], frames[s - 15], frames[s - 14], frames[s - 13], frames[s - 12], frames[s - 11], frames[s - 10], frames[s - 9 ], 
										frames[s - 8 ], frames[s - 7 ], frames[s -  6], frames[s - 5 ], frames[s - 4 ], frames[s - 3 ], frames[s - 2 ], frames[s - 1 ], }
				);
				frames.push_back(checkS);

			}*/
			fin >> currFrame;
			//cout << "currFrame: " << currFrame << endl;
			//fin.getline(fin, currFrame);
			
			frames.push_back(currFrame);
			tmp1 = currFrame;

			frameCnt++;
			i++;
		}
		//frames.pop_back();
		
		for (size_t i{ 0 }; i < frames.size(); i++) {
			if (i % 8 == 0 && i != 0) {
				packs.push_back(currPack);	
				currPack.frames.clear();
			}
			//if (i % 24 == 0 && i != 0) {
			//	uint8_t checkS;
			//	checkS = getCheckSum({ frames[i - 24], frames[i - 23], frames[i - 22], frames[i - 21], frames[i - 20], frames[i - 19], frames[i - 18], frames[i - 17],
			//							frames[i - 16], frames[i - 15], frames[i - 14], frames[i - 13], frames[i - 12], frames[i - 11], frames[i - 10], frames[i - 9],
			//							frames[i - 8], frames[i - 7], frames[i - 6], frames[i - 5], frames[i - 4], frames[i - 3], frames[i - 2], frames[i - 1], }
			//	);
			//	
			//	
			//	cout <<endl<< "checkS "<< bitset<8>(checkS) << endl;
			//	//currPack.frames.push_back(checkS);
			//	
			//	
			//}
			currPack.frames.push_back(frames[i]);
		}

		/*uint8_t currCheckSum;
		for (size_t i{ 0 }; i < packs.size(); i++) {
			if (i % 3 == 0 && i != 0) {
				currCheckSum = getCheckSum({ packs[i].frames[i - 3], packs[i].frames[i - 2], packs[i].frames[i - 1] });
				packs[i].frames.push_back(currCheckSum);
			}
		}*/
	}
	else {
		cout << "Error! Input file not found." << endl;
	}

	fin.close();
	return packs;
}
void receiver(vector<Package> packs) {
	for (size_t i{ 0 }; i < packs.size(); i++) {
		
	}
}
