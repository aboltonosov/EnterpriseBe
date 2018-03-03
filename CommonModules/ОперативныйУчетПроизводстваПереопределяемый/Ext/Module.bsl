﻿////////////////////////////////////////////////////////////////////////////////
// ОУП: Переопределяемые процедуры подсистемы оперативного учета производства
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ФормированиеРасписанияРабочихЦентров

// Инициирует расчет пооперационного расписания производства.
//
// Параметры:
//  ПараметрыРасчета - Структура - см. функцию Обработка.ПооперационноеПланирование.ПараметрыРасчетаПооперационногоРасписания.
//  АдресХранилища - УникальныйИдентификатор, Строка - адрес во временном хранилище, по которому надо поместить результаты расчета расписания.
//
Процедура РассчитатьПооперационноеРасписание(ПараметрыРасчета, АдресХранилища) Экспорт

	Обработки.ПооперационноеПланирование.РассчитатьРасписание(ПараметрыРасчета, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

#КонецОбласти

#КонецОбласти
