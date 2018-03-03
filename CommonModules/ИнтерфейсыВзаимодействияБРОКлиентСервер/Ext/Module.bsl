﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции интерфейса перечисления "Периодичность".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает начало периода даты.
//
// Параметры:
//   Периодичность - Перечисление.Периодичность - периодичность.
//   Дата - Дата - дата.
//
// Возвращаемое значение:
//   Дата - начало периода даты.
//
Функция НачалоПериода(Периодичность, Дата) Экспорт
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат НачалоГода(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		НомерМесяца = Месяц(Дата);
		
		Если НомерМесяца < 7 Тогда
			Возврат НачалоГода(Дата);
		Иначе
			Возврат ДобавитьМесяц(НачалоГода(Дата), 6);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат НачалоКвартала(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат НачалоМесяца(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат НачалоНедели(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		День = 24 * 60 * 60; // Количество секунд в дне
		
		НомерДня = День(Дата);
		
		Если НомерДня <= 10 Тогда
			Возврат НачалоМесяца(Дата);
		ИначеЕсли НомерДня <= 20 Тогда
			Возврат НачалоМесяца(Дата) + 10 * День;
		Иначе
			Возврат НачалоМесяца(Дата) + 20 * День;
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Возврат НачалоДня(Дата);
		
	Иначе
		
		Возврат Дата;
		
	КонецЕсли;
	
КонецФункции

// Возвращает конец периода.
//
Функция КонецПериода(Периодичность, Дата) Экспорт
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат КонецГода(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		НомерМесяца = Месяц(Дата);
		Если НомерМесяца < 7 Тогда
			Возврат КонецМесяца(ДобавитьМесяц(НачалоГода(Дата), 5));
		Иначе
			Возврат КонецГода(Дата);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат КонецКвартала(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат КонецМесяца(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат КонецНедели(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		День = 24 * 60 * 60; // Количество секунд в дне
		
		НомерДня = День(Дата);
		Если НомерДня <= 10 Тогда
			Возврат НачалоМесяца(Дата) + 10 * День - 1;
		ИначеЕсли НомерДня <= 20 Тогда
			Возврат НачалоМесяца(Дата) + 20 * День - 1;
		Иначе
			Возврат КонецМесяца(Дата);
		КонецЕсли;
		
	Иначе
		
		Возврат КонецДня(Дата);
		
	КонецЕсли;
	
КонецФункции

// Добавляет период.
//
Функция ДобавитьПериод(Знач Дата, Периодичность, Знач КоличествоПериодов = 1) Экспорт
	
	Если КоличествоПериодов = 0 Тогда
		КоличествоПериодов = 1;
	КонецЕсли;
	
	День = 24 * 60 * 60; // Количество секунд в дне
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат ДобавитьМесяц(Дата, 12 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Возврат ДобавитьМесяц(Дата, 6 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат ДобавитьМесяц(Дата, 3 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат ДобавитьМесяц(Дата, 1 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат Дата + 7 * День * КоличествоПериодов;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		Возврат Дата + 10 * День * КоличествоПериодов;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Возврат Дата + 1 * День * КоличествоПериодов;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти