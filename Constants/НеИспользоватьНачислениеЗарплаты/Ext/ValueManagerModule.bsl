﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенный.УстановитьПараметрыНабораСвойствСовмещение();
КонецПроцедуры

#КонецОбласти

#КонецЕсли
