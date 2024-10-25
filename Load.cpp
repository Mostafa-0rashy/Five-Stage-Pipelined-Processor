#include "Load.h"
#include <istream>
#include<fstream>
#include <string>
#include<iostream>
#include <algorithm>
#include <sstream>
#include <iomanip>
using namespace std;

string Load::BinaryOperands(int RegNumber) {
	string binary = "";
	if (RegNumber == 0) {
		binary = "000";
	}
	else if (RegNumber > 0) {
		for (int i = 2; i >= 0; i--) {
			binary = std::to_string(RegNumber & 1) + binary;
			RegNumber >>= 1;
		}
	}

	return binary;
}
std::string toUpperCase(const std::string& str)
{
	std::string result = str;

	transform(result.begin(), result.end(), result.begin(), [](unsigned char c)
		{
			return std::toupper(c);
		});
	return result;
}
string Load::ImmediateValueBinary(int Imm) {
	std::string binary = "";
	int Immabs = std::abs(Imm);
	// Handle the case when the number is 0
	if (Immabs == 0) {
		binary = "0";
	}
	else {
		while (Immabs > 0) {
			binary = std::to_string(Immabs % 2) + binary;
			Immabs /= 2;
		}
	}
	return binary;
}
string Load::ImmediateValueHex(string hex) {

	string binary[4];
	string binarystring;
	bool negative = 0;
	if (hex[0] == '-')
	{
		negative = 1;

		hex = hex.substr(1, hex.size() - 1);

	}

	if (hex.size() != 4)
	{
		int size = hex.size();
		for (int i = 0; i < 4 - size; i++)
		{
			hex = "0" + hex;
		}
	}
	for (int i = 0; i < hex.size(); i++)
	{
		char hexDigit = hex[i];
		if (hexDigit == '0') binary[i] = "0000";
		else if (hexDigit == '1') binary[i] = "0001";
		else if (hexDigit == '2') binary[i] = "0010";
		else if (hexDigit == '3') binary[i] = "0011";
		else if (hexDigit == '4') binary[i] = "0100";
		else if (hexDigit == '5') binary[i] = "0101";
		else if (hexDigit == '6') binary[i] = "0110";
		else if (hexDigit == '7') binary[i] = "0111";
		else if (hexDigit == '8') binary[i] = "1000";
		else if (hexDigit == '9') binary[i] = "1001";
		else if (hexDigit == 'A' || hexDigit == 'a') binary[i] = "1010";
		else if (hexDigit == 'B' || hexDigit == 'b') binary[i] = "1011";
		else if (hexDigit == 'C' || hexDigit == 'c') binary[i] = "1100";
		else if (hexDigit == 'D' || hexDigit == 'd') binary[i] = "1101";
		else if (hexDigit == 'E' || hexDigit == 'e') binary[i] = "1110";
		else if (hexDigit == 'F' || hexDigit == 'f') binary[i] = "1111";
	}

	binarystring = binary[0] + binary[1] + binary[2] + binary[3];
	if (negative)
	{
		binarystring[0] = '1'; //abcde
	}
	return binarystring;

}
void Load::Execute(bool read)
{
	string line;
	string opcode;
	string operand1;
	string operand2;
	string operand3;
	string immValue;
	string Outinstruction;
	ifstream Infile;
	string instructions[4096];
	int currentline =0;
	Infile.open("Instructions.txt", ios::in);
	ofstream outFile("Out.mem", ios::out);
	int line_number = 0;
	if (Infile.fail()) //if file name is invaild
	{
		cout << "File didn't successfully open";
		return;
	}
	else
	{
		string instructionbinary;
		cout << "File Opened";
		while (!Infile.eof())
		{


			if (currentline < line_number)
			{
				currentline = line_number;
			}
			string instruction; //instruction
			Infile >> instruction;
			if (instruction[0] == '#')
			{
				string dummy;
				Infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
				continue;
			}
			else if (instruction[0] == '.')
			{
				string numberstr;
				Infile >> numberstr;

				int num = std::stoi(numberstr, nullptr, 16);

				for (line_number; line_number < num; line_number++)
				{

					instructions[line_number ] = "0000000000000000";
					//outFile << "0000000000000000" << endl;
				}

				if (num < line_number)
				{
					//outFile.seekp(num);
					line_number = num;
				}

				Infile >> instruction;
				if (instruction[0] == '#')
				{
					string dummy;
					Infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
					Infile >> instruction;
				}
				if (instruction.find_first_not_of("0123456789ABCDEFabcdef") == std::string::npos && instruction != "ADD" && instruction != "add")
				{
					if (instruction.size() == 1 or instruction.size() == 2 or instruction.size() == 3 or instruction.size() == 4)
					{
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction) << endl;
						line_number++;
					}
					else if (instruction.size() == 5)
					{
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(0, 4)) << endl;
						line_number++;
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(std::to_string(instruction[4])) << endl;
						line_number++;
					}
					else if (instruction.size() == 6)
					{
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(0, 4)) << endl;
						line_number++;
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(5, 6)) << endl;
						line_number++;
					}
					else if (instruction.size() == 7)
					{
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(0, 4)) << endl;
						line_number++;
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(5, 7)) << endl;
						line_number++;
					}
					else if (instruction.size() == 8)
					{
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(0, 4)) << endl;
						line_number++;
						instructions[line_number] = ImmediateValueHex(instruction);
						//outFile << ImmediateValueHex(instruction.substr(5, 8)) << endl;
						line_number++;
					}

					continue;

				}


			}
			instruction = toUpperCase(instruction);
			if (instruction == "ADD" || instruction == "XOR"
				|| instruction == "ADDI" || instruction == "SUB" || instruction == "SUBI" || instruction == "AND" || instruction == "OR" || instruction == "LDD" || instruction == "STD")
				//////////////// THREE OPERANDS/////////////////////
			{
				//////////////Decoding Instrcution///////////////
				if (instruction == "ADD") {

					instructionbinary = "001010";
					//outFile << opcode;

				}
				else if (instruction == "XOR") {

					instructionbinary = "001110";
					//outFile << opcode;

				}
				else if (instruction == "ADDI") {

					instructionbinary = "101010";
					//outFile << opcode;

				}
				else if (instruction == "SUB") {

					instructionbinary = "001011";
					//outFile << opcode;

				}
				else if (instruction == "SUBI") {

					instructionbinary = "101011";
					//outFile << opcode;

				}
				else if (instruction == "AND") {

					instructionbinary = "001100";
					//outFile << opcode;


				}
				else if (instruction == "OR") {

					instructionbinary = "001101";
					//outFile << opcode;


				}
				else if (instruction == "LDD") {

					instructionbinary = "110011";
					//outFile << opcode;


				}
				else if (instruction == "STD") {

					instructionbinary = "110100";
					//outFile << opcode;


				};
				//////////////Reading Operand1///////////////
				char temp1;
				char temp2;
				if (instruction != "STD" and instruction != "LDD")
				{

					string temp3;
					Infile.get(temp1);
				}
				else
				{
					instructionbinary = instructionbinary + "000";
					string temp3;
					Infile.get(temp1);
				}
				while (temp1 == ' ')
				{

					Infile.get(temp1);
				};
				Infile.get(temp2);
				operand1 = BinaryOperands(temp2 - '0');
				if (temp1 != '#')
				{
					instructionbinary = instructionbinary + operand1;

				}

				if (instruction == "ADDI" || instruction == "SUBI")
				{
					//////////////Reading Operand2///////////////
					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == '(' || temp1 == ','))
					{

						Infile.get(temp1);
					}

					Infile.get(temp2);
					operand2 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand2 + "0000";
					instructions[line_number] = instructionbinary;
					line_number++;
					//////////////Reading Immediate value///////////////
					char immValueint;
					do
					{

						Infile.get(immValueint);

					} while (Infile.peek() == ' ' || Infile.peek() == ',');
					immValue = std::string(1, immValueint);
					string immvaluerest;
					Infile >> immValue;
					//immValue = ImmediateValueBinary(std::stoi(immValue));
					immValue = ImmediateValueHex(immValue);
					instructions[line_number] =  immValue;
					line_number++;

				}
				else if (instruction == "LDD" || instruction == "STD")
				{



					//////////////Reading Immediate value///////////////

					char immValueint;
					Infile.get(immValueint);
					while (immValueint == ' ' || immValueint == ',')
					{

						Infile.get(immValueint);
					};
					immValue = std::string(1, immValueint);
					char immvaluerest;
					Infile.get(immvaluerest);
					while (immvaluerest != '(')
					{

						immValue = immValue + std::string(1, immvaluerest);
						Infile.get(immvaluerest);
					}


					//////////////Reading Operand2///////////////
					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == '(' || temp1 == ','))
					{

						Infile.get(temp1);
					}

					Infile.get(temp2);
					operand2 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand2 + "0";
					instructions[line_number] = instructionbinary;
					line_number++;


					instructions[line_number] = ImmediateValueHex(immValue);
					line_number++;
					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == ')'))
					{

						Infile.get(temp1);
						if (Infile.eof()) {
							break;
						}
					}
				}
				else
				{
					//////////////Reading Operand2///////////////
					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == ','))
					{

						Infile.get(temp1);
					}

					Infile.get(temp2);
					operand2 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand2;

					//////////////Reading Operand3///////////////

					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == ','))
					{

						Infile.get(temp1);
					}

					Infile.get(temp2);
					operand3 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand3 + "0";
					instructions[line_number] = instructionbinary;
					line_number++;
				}

			}
			////////////////////////TWO OPERAND////////////////////////////////
			else if (instruction == "MOV" || instruction == "SWAP" || instruction == "CMP" || instruction == "LDM" || instruction == "STD")
			{
				if (instruction == "MOV")
				{
					instructionbinary = "001000";
					//outFile << opcode;
				}
				else if (instruction == "SWAP")
				{
					instructionbinary = "001001";
					//outFile << opcode;
				}
				else if (instruction == "LDM")
				{
					instructionbinary = "110010";
					//outFile << opcode;

				}
				else if (instruction == "CMP")
				{
					instructionbinary = "001111000" ;

					//outFile << opcode;
					//outFile << "000";
				}

				if (instruction == "LDM")
				{
					char temp1;
					char temp2;
					Infile.get(temp1);
					while (temp1 == ' ')
					{

						Infile.get(temp1);
					}
					Infile.get(temp2);
					///////////Taking Operand 1//////////////////
					operand1 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand1;
					instructionbinary = instructionbinary + "0000000";
					instructions[line_number] = instructionbinary;
					line_number++;
					string imm1;
					Infile.get(temp1);
					Infile >> imm1;
					imm1 = ImmediateValueHex(imm1);
					instructions[line_number] = imm1;
					line_number++;
				}
				else
				{
					char temp1;
					char temp2;
					Infile.get(temp1);
					while (temp1 == ' ')
					{

						Infile.get(temp1);
					}
					Infile.get(temp2);
					///////////Taking Operand 1//////////////////
					operand1 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand1;

					Infile.get(temp1);
					while ((temp1 == ' ' || temp1 == ','))
					{

						Infile.get(temp1);
					}


					Infile.get(temp2);

					///////////////Taking Operand 2//////////////

					operand2 = BinaryOperands(temp2 - '0');
					instructionbinary = instructionbinary + operand2;
				}

				if (instruction != "LDM")
				{

					if (instruction != "CMP")
					{
						instructionbinary = instructionbinary + "0000";
					}
					else
					{

						instructionbinary = instructionbinary + "0";
					}
					instructions[line_number] = instructionbinary;
					line_number++;
					//do nothing
				}


			}
			//////////////////////ONE OPERAND//////////////////////////////
			else if (instruction == "JZ" || instruction == "JMP" || instruction == "CALL" || instruction == "NEG" || instruction == "NOT" || instruction == "INC"
				|| instruction == "DEC" || instruction == "OUT" || instruction == "IN" || instruction == "POP" || instruction == "PUSH"
				|| instruction == "PROTECT" || instruction == "FREE")
			{
				//////////////Decoding Instrcution///////////////
				if (instruction == "JZ")
				{
					instructionbinary = "011000";
				}
				else if (instruction == "JMP")
				{
					instructionbinary = "011001";
				}
				else if (instruction == "CALL")
				{
					instructionbinary = "011010";
				}
				else if (instruction == "NEG")
				{
					instructionbinary = "000001";
				}
				else if (instruction == "NOT")
				{
					instructionbinary = "000011";
				}
				else if (instruction == "INC")
				{
					instructionbinary = "000100";
				}
				else if (instruction == "DEC")
				{
					instructionbinary = "000101";
				}
				else if (instruction == "OUT")
				{
					instructionbinary = "000110";
				}
				else if (instruction == "IN")
				{
					instructionbinary = "000111";
				}
				else if (instruction == "POP")
				{
					instructionbinary = "010001";
				}
				else if (instruction == "PUSH")
				{
					instructionbinary = "010000";
				}
				else if (instruction == "PROTECT")
				{
					instructionbinary = "010101";
				}
				else if (instruction == "FREE")
				{
					instructionbinary = "010110";
				}
				char temp1;
				char temp2;
				Infile.get(temp1);
				while (temp1 == ' ')
				{
					Infile.get(temp1);
				}
				Infile.get(temp2);
				operand1 = std::string(1, temp1) + std::string(1, temp2);//operand 1 taken

				if (operand1 == "R0" || operand1 == "r0")
				{
					instructionbinary = instructionbinary + "0000000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R1" || operand1 == "r1")
				{
					instructionbinary = instructionbinary + "0010000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R2" || operand1 == "r2")
				{
					instructionbinary = instructionbinary + "0100000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R3" || operand1 == "r3")
				{
					instructionbinary = instructionbinary + "0110000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R4" || operand1 == "r4")
				{
					instructionbinary = instructionbinary + "1000000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R5" || operand1 == "r5")
				{
					instructionbinary = instructionbinary + "1010000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R6" || operand1 == "r6")
				{
					instructionbinary = instructionbinary + "1100000000";
					//outFile << Outinstruction;
				}
				else if (operand1 == "R7" || operand1 == "r7")
				{
					instructionbinary = instructionbinary + "1110000000";
					//outFile << Outinstruction;
				}
				instructions[line_number] = instructionbinary;
				line_number++;
			}
			////////////////////ZERO OPERAND//////////////////////////////
			else if (instruction == "NOP" || instruction == "RET" || instruction == "RTI" || instruction == "RESET" || instruction == "INT")
			{
				if (instruction == "NOP")
				{
					instructionbinary = "000000";
				}
				else if (instruction == "RET")
				{
					instructionbinary = "011011";
				}
				else if (instruction == "RTI")
				{
					instructionbinary = "011100";
				}
				else if (instruction == "RESET")
				{
					instructionbinary = "111111";
				}
				else if (instruction == "INT")
				{
					instructionbinary = "111000";
				}
				instructionbinary = instructionbinary + "0000000000";
				instructions[line_number] = instructionbinary;
				line_number++;
			}


		}
	}

	if (currentline == 0)
	{
		currentline = line_number;
	}

	for (int i = 0; i < currentline; i++)
	{
		outFile << instructions[i] << endl;
	}
};