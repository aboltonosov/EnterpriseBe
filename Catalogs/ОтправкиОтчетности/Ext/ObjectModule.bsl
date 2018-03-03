﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СдачаОтчетностиЧерезСервисСпецоператораВызовСервера.ПриЗаписиОтправкиОтчетности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = СгенерироватьНаименование();
	КонецЕсли;
	
	ПредставлениеПериода = ПредставлениеПериода(НачалоДня(ДатаНачалаПериода), КонецДня(ДатаОкончанияПериода), "ФП=Истина");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СгенерироватьНаименование()
	
	Возврат "Отправка """ + ВидОтчета
			+ ?(ВидДокумента = 0, "", " (корр. " + Формат(ВидДокумента, "ЧГ=") + ") ")
			+ """ за " + ПредставлениеПериода(НачалоДня(ДатаНачалаПериода), КонецДня(ДатаОкончанияПериода), "ФП=Истина")
			+ " по " + Организация;
	
КонецФункции

#КонецОбласти

#КонецЕсли