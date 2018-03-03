﻿
#Область ПрограммныйИнтерфейс

// Инициализирует параметры, обслуживающие выбор назначений в формах документа.
// 
//  Возвращаемое значение:
//  Структура - структура параметров, см. Справочники.Назначения.МакетФормыВыбораНазначений().
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы);
	
	// Все назначения для поля Назначение в шапке.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ВсеНазначения", Ложь, "Объект.Назначение");
	
	Возврат МакетФормы;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Обеспечение

// Возвращает текст запроса для получениях доступных назначений
//	Параметры:
//		ПараметрыФормированияЗапроса - Структура - параметры для формирования текстов запросов
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса) Экспорт
	
	Возврат Справочники.Назначения.ТекстЗапросаНазначенийРасширенный();
	
КонецФункции

#КонецОбласти

#КонецОбласти