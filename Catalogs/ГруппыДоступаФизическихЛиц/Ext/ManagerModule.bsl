﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Функция определяет, используются или нет группы доступа физических лиц
//
//	Возвращаемое значение:
//		Булево - если ИСТИНА, значит группы доступа используются
//
Функция ИспользуютсяГруппыДоступа() Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГруппыДоступаФизическихЛиц.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступаФизическихЛиц КАК ГруппыДоступаФизическихЛиц";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли