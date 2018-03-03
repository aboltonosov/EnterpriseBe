﻿
#Область ПрограммныйИнтерфейс

// Получить типы подключенного оборудования.
// 
// Возвращаемое значение:
//  Массив - Типы подключенного оборудования.
//
Функция ТипыПодключенногоОборудования() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.УстройствоИспользуется
		|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		
		Результат = Запрос.Выполнить();
		
		Возврат Результат.Выгрузить().ВыгрузитьКолонку("ТипОборудования");
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
