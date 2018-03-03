﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбора = Новый СписокЗначений;
	
	ДоступныеТипыОборудования = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьДоступныеТипыОборудования();
	ИндексЭлемента = ДоступныеТипыОборудования.Найти(Перечисления.ТипыПодключаемогоОборудования.WebСервисОборудование);
	Если НЕ ИндексЭлемента = Неопределено Тогда
		ДоступныеТипыОборудования.Удалить(ИндексЭлемента);
	КонецЕсли;
	
	ДанныеВыбора.ЗагрузитьЗначения(ДоступныеТипыОборудования);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти